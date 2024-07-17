//
//  TMediaCell.swift
//  empmgmt
//
//  Created by Ryan on 15/4/24.
//

import SwiftUI

struct PickedMediaCell: View {
    let media: PickedMedia
    
    @State private var imageData: ImageData?
    @State private var videoURL: URL?
    
    init(_ media: PickedMedia) {
        self.media = media
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .aspectRatio(1, contentMode: .fill)
            .overlay {
                if let data = imageData {
                    Image(imageData: data)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .overlay {
                if media.type == .video {
                    Image(systemName: "play.circle.fill")
                        .foregroundStyle(.ultraThickMaterial)
                        .font(.title)
                        .opacity(5.0)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
            .clipped()
            .onAppear {
                build()
            }
    }
    
    // MARK: Content
    func build() {
        Task {
            let thumbnail = await media.getThumbnailData()
            if let data = thumbnail {
                DispatchQueue.main.async {
                    imageData = ImageData(data: data)
                }
            }
        }
    }
}

//#Preview {
//    TMediaCell()
//}
