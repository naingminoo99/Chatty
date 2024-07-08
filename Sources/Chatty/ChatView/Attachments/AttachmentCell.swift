//
//  Created by Alex.M on 16.06.2022.
//

import SwiftUI
import Kingfisher
import Amplify

struct AttachmentCell: View {

    @Environment(\.chatTheme) private var theme

    let attachment: Attachment
    let onTap: (Attachment) -> Void

    var body: some View {
        Group {
            if attachment.type == .image {
                content
            } else if attachment.type == .video {
                content
                    .overlay {
                        theme.images.message.playVideo
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                    }
            } else {
                content
                    .overlay {
                        Text("Unknown")
                    }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap(attachment)
        }
    }

    var content: some View {
        //        AsyncImageView(url: attachment.thumbnail)
        
        // Key is js a name so add your message media patch here
        let keyWithPath = "messageImages/" + attachment.thumbnail
        return LazyImageView(key: keyWithPath)
    }
}

struct AsyncImageView: View {

    @Environment(\.chatTheme) var theme
    let url: URL

    var body: some View {
        CachedAsyncImage(url: url, urlCache: .imageCache) { imageView in
            imageView
                .resizable()
                .scaledToFill()
        } placeholder: {
            ZStack {
                Rectangle()
                    .foregroundColor(theme.colors.inputLightContextBackground)
                    .frame(minWidth: 100, minHeight: 100)
                ActivityIndicator(size: 30, showBackground: false)
            }
        }
    }
}

struct LazyImageView: View {
    
    let key: String
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var contentMode: SwiftUI.ContentMode = .fill
    var placeholderName: String?
    
    @State private var url: URL?
    
    init(key: String,
         width: CGFloat? = nil,
         height: CGFloat? = nil,
         contentMode: SwiftUI.ContentMode = .fill,
         placeholderName: String? = nil) {
        self.key = key
        self.width = width
        self.height = height
        self.contentMode = contentMode
        self.placeholderName = placeholderName
    }
    
    var body: some View {
        // Fallback on earlier versions
        KFImage.url(url, cacheKey: key)
            .resizable()
            .placeholder { progress in
                ProgressView()
            }
            .onFailureImage(UIImage(named: placeholderName ?? "placeholder"))
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height, alignment: .center)
            .clipped()
            .onAppear {
                if url == nil {
                    loadURL()
                }
            }
    }
    
    
    // load URL
    func loadURL() {
        Task {
            do {
                let presign = try await Amplify.Storage.getURL(key: key)
                DispatchQueue.main.async {
                    withAnimation() {
                        self.url = presign
                    }
                }
            } catch {
                // Handle the error when fetching the URL
                if let amplifyError = error as? AmplifyError {
                    print("AmplifyError details: \(amplifyError.errorDescription)")
                }
            }
        }
    }
    
}
