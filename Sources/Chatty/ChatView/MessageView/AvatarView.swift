//
//  Created by Alex.M on 07.07.2022.
//

import SwiftUI

struct AvatarView: View {

    let avatarKey: String
    let avatarSize: CGFloat

    var body: some View {
        LazyImageView(key: avatarKey)
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
