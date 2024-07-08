//
//  ImageData.swift
//  empmgmt
//
//  Created by Ryan on 15/4/24.
//

import SwiftUI

#if os(macOS)
typealias ImageData = NSImage
#else
typealias ImageData = UIImage
#endif

extension Image {
  init(imageData: ImageData) {
    #if os(macOS)
    self.init(nsImage: imageData)
    #else
    self.init(uiImage: imageData)
    #endif
  }
}
