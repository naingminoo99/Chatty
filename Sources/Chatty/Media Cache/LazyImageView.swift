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
    
    @State private var viewModel: ViewModel
    
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
        self._viewModel = State(initialValue: ViewModel(key: key))
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .frame(width: width, height: height, alignment: .center)
            case .error(let error):
                Image(placeholderName ?? "placeholder")
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height, alignment: .center)
                    .clipped()
            case .loaded:
                KFImage.url(viewModel.url, cacheKey: key)
                    .resizable()
                    .placeholder { _ in
                        ProgressView()
                    }
                    .onFailureImage(UIImage(named: placeholderName ?? "placeholder"))
                    .fade(duration: 0.25)
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .clipped()
            }
        }
    }
    
}
