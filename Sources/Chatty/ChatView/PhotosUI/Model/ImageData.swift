//
//  ImageData.swift
//  empmgmt
//
//  Created by Ryan on 15/4/24.
//

import SwiftUI

#if os(macOS)
public typealias ImageData = NSImage
#else
public typealias ImageData = UIImage
#endif

extension Image {
  public init(imageData: ImageData) {
    #if os(macOS)
    self.init(nsImage: imageData)
    #else
    self.init(uiImage: imageData)
    #endif
  }
}
