//
//  NMediaPickerCell.swift
//  empmgmt
//
//  Created by Ryan on 15/4/24.
//

import SwiftUI
import PhotosUI

public struct MediaPickerCell: View {
    
    // MARK: Properties
    var cellSize: CGFloat = 100
    @Binding var medias: [PickedMedia]
    @State var photoPickerItems: [PhotosPickerItem] = []
    @State var error: Error?
    @State var didError = false
    @State private var showMediaPicker = false
    
    public init(medias: Binding<[PickedMedia]>, cellSize: CGFloat = 100) {
        self._medias = medias
        self.cellSize = cellSize
    }
    
    // MARK: Views
    public var body: some View {
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: cellSize))], alignment: .leading, spacing: 10) {
            Rectangle()
                .background(.tertiary)
                .foregroundStyle(.tertiary)
                .aspectRatio(1, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .overlay {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .contentShape(Rectangle())
                        .clipped()
                        .onTapGesture {
                            showMediaPicker.toggle()
                        }
                }
            
            ForEach(Array(medias)) { media in
                PickedMediaCell(media)
            }
        }
        .alert("Error", isPresented: $didError) {
            Button("Close") {
                print(error!)
            }
        }
        .photosPicker(
            isPresented: $showMediaPicker,
            selection: $photoPickerItems,
            maxSelectionCount: 10,
            selectionBehavior: .ordered,
            matching: .any(of: [.images, .videos]),
            preferredItemEncoding: .current,
            photoLibrary: .shared()
        )
        .onChange(of: photoPickerItems) { value in
            Task {
                do {
                    try await loadPhotos(with: value)
                } catch let newError {
                    error = newError
                    didError.toggle()
                }
            }
        }
    }
    
    // MARK: Methods
    
    func loadPhotos(with pickers: [PhotosPickerItem]) async throws {
        let oldPhotos = medias
        var newPhotos: [PickedMedia] = []
        
        for picker in pickers {
            if let foundPhoto = oldPhotos.first(where: { $0.id == picker.itemIdentifier }) {
                newPhotos.append(foundPhoto)
            } else {
                let item = try await PickedMedia.loadData(picker)
                newPhotos.append(item)
            }
            medias = newPhotos
        }
        medias = newPhotos
    }
}

#Preview {
    MediaPickerCell(medias: .constant([]))
}
