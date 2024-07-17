//
//  PhotosPickerItem+Extension.swift
//  empmgmt
//
//  Created by Ryan on 15/4/24.
//

import PhotosUI
import SwiftUI

extension AVAsset {
    func generateThumbnail() -> Data? {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            guard let data = thumbnailImage.jpegData else { return nil }
            return data
        } catch let error {
            print(error)
        }
        return nil
    }
}

extension CGImage {
    var jpegData: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, UTType.jpeg.identifier as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}

extension PhotosPickerItem {
  func loadPhoto() async throws -> Any {
    if let livePhoto = try await self.loadTransferable(type: PHLivePhoto.self) {
      return livePhoto
    } else if let movie = try await self.loadTransferable(type: Video.self) {
      return movie
    } else if let data = try await self.loadTransferable(type: Data.self) {
      if let image: ImageData = .init(data: data) {
        return image
      }
    }

    fatalError()
  }
}
