//
//  Created by Alex.M on 17.06.2022.
//

import Foundation

public struct DraftMessage {
    public var id: String?
    public let text: String
    public let medias: [PickedMedia]
    public let recording: Recording?
    public let replyMessage: ReplyMessage?
    public let createdAt: Date

    public init(id: String? = nil, 
                text: String,
                medias: [PickedMedia],
                recording: Recording?,
                replyMessage: ReplyMessage?,
                createdAt: Date) {
        self.id = id
        self.text = text
        self.medias = medias
        self.recording = recording
        self.replyMessage = replyMessage
        self.createdAt = createdAt
    }
}
