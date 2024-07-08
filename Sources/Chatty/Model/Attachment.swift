//
//  Created by Alex.M on 16.06.2022.
//

import Foundation

public enum AttachmentType: String, Codable {
    case image
    case video

    public var title: String {
        switch self {
        case .image:
            return "Image"
        default:
            return "Video"
        }
    }

    public init(mediaType: PickedMediaType) {
        switch mediaType {
        case .video:
            self = .video
        default:
            self = .image
        }
    }
}

public struct Attachment: Codable, Identifiable, Hashable {
    public let id: String
    public let thumbnail: String
    public let full: String
    public let type: AttachmentType
    
    public init(id: String, thumbnail: String, full: String, type: AttachmentType) {
        self.id = id
        self.thumbnail = thumbnail
        self.full = full
        self.type = type
    }

    public init(id: String, key: String, type: AttachmentType) {
        self.init(id: id, thumbnail: key, full: key, type: type)
    }
}
