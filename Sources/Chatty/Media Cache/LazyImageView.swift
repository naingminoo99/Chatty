//
//  SwiftUIView.swift
//  Chat
//
//  Created by Ryan  on 17/7/24.
//

import SwiftUI
import Kingfisher
import Amplify

struct LazyImageView: View {
    
    let key: String
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var contentMode: SwiftUI.ContentMode = .fill
    var placeholderName: String?
    
    @State private var url: URL?
    @State private var isLoading = true
    
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
        Group {
            if let url = url {
                KFImage(url)
                    .resizable()
                    .placeholder { _ in
                        ProgressView()
                    }
                    .onFailureImage(UIImage(named: placeholderName ?? "placeholder"))
                    .fade(duration: 0.25)
                    .cacheOriginalImage() // Cache original image
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .clipped()
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height, alignment: .center)
            } else {
                Image(placeholderName ?? "placeholder")
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height, alignment: .center)
                    .clipped()
            }
        }
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
                    withAnimation {
                        self.url = presign
                        self.isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                // Handle the error when fetching the URL
                if let amplifyError = error as? AmplifyError {
                    print("AmplifyError details: \(amplifyError.errorDescription)")
                }
            }
        }
    }
}
