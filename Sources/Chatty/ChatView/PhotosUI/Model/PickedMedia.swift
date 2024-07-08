//
//  PickedMedia.swift
//  empmgmt
//
//  Created by Ryan on 15/4/24.
//

import SwiftUI
import PhotosUI

public enum PickedMediaType {
    case photo, video
}

public struct PickedMedia: Identifiable, Equatable {
    public let id: String?
    public let imageData: Data?
    public let videoURL: URL?
    public let type: PickedMediaType
    
    init(id: String?) {
        self.id = id
        self.imageData = nil
        self.videoURL = nil
        self.type = .photo
    }
    
    init(id: String?, url: URL) {
        self.id = id
        self.imageData = nil
        self.videoURL = url
        self.type = .video
    }
    
    init(id: String?, data: Data) {
        self.id = id
        self.imageData = data
        self.videoURL = nil
        self.type = .photo
    }
    
    func getData() async -> Data? {
        switch self.type {
        case .photo:
            if let data = self.imageData {
                return data
            }
            return nil
        case .video:
            if let url = videoURL {
                let videoData = try? Data(contentsOf: url)
                return videoData
            }
            return nil
        }
    }
    
    func getThumbnailData() async -> Data? {
        switch self.type {
        case .photo:
            let data = await self.getData()
            return data
        case .video:
            guard let url = getURL() else { return nil }
            let asset: AVAsset = AVAsset(url: url)
            return asset.generateThumbnail()
        }
    }
    
    func getURL() -> URL? {
        if let vdoUrl = videoURL {
            return vdoUrl
        }
        return nil
    }
    
    func getImageData() -> ImageData? {
        if let data = self.imageData {
            return ImageData(data: data)
        } else {
            return nil
        }
    }
    
    public static func loadData(_ item: PhotosPickerItem) async throws -> PickedMedia {
        if let movie = try await item.loadTransferable(type: Video.self) {
            return PickedMedia(id: item.itemIdentifier, url: movie.url)
        } else if let data = try await item.loadTransferable(type: Data.self) {
            return PickedMedia(id: item.itemIdentifier, data: data)
        }
        fatalError()
    }
}


