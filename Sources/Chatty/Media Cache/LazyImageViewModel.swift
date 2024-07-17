//
//  File.swift
//  Chat
//
//  Created by Ryan  on 17/7/24.
//

import SwiftUI
import Swift
import Amplify

extension LazyImageView {
    
    enum ViewState: Equatable, Hashable {
        case loading, loaded, error(any Error)
        
        
        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            case (.error(_), .error(_)):
                return false
            default:
                return false
            }
        }
        
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .loading:
                hasher.combine("loading")
            case .loaded:
                hasher.combine("loaded")
            case .error(let error):
                hasher.combine((error as NSError).domain)
                hasher.combine((error as NSError).code)
            }
        }
        
    }
    
    
    @Observable
    class ViewModel {
        
        var viewState: ViewState
        var key: String
        var url: URL?
        
        init(key: String, url: URL? = nil) {
            self.viewState = .loading
            self.key = key
            loadURL()
        }
        
        
        // load URL
        func loadURL() {
            Task {
                do {
                    let presign = try await Amplify.Storage.getURL(key: key)
                    DispatchQueue.main.async {
                        withAnimation {
                            self.url = presign
                            self.viewState = .loaded
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.viewState = .error(error)
                    }
                }
            }
        }

        
    }
}
