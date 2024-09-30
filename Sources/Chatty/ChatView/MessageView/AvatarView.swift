//
//  Created by Alex.M on 07.07.2022.
//

import SwiftUI
import MediaCache

struct AvatarView: View {
    
    @Environment(\.urlLoader) private var urlLoader

    let avatarKey: String
    let avatarSize: CGFloat

    var body: some View {
        LazyImageView(key: avatarKey, urlLoader: urlLoader)
        .viewSize(avatarSize)
        .clipShape(Circle())
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(
            avatarKey: "avatar",
            avatarSize: 32
        )
    }
}
