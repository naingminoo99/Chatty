//
//  Created by Alex.M on 17.06.2022.
//

import Foundation

public struct User: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let avatarKey: String
    public let isCurrentUser: Bool

    public init(id: String, name: String, avatarKey: String, isCurrentUser: Bool) {
        self.id = id
        self.name = name
        self.avatarKey = avatarKey
        self.isCurrentUser = isCurrentUser
    }
}
