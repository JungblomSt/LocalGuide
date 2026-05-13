
// Liked guides and liked creators

import SwiftUI

struct LikedView: View {
    var body: some View {
        LikedGuideView()
        LikedCreatorView()
    }
}

#Preview {
    LikedView()
}

struct LikedGuideView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

struct LikedCreatorView: View {
    var body: some View {
        Text("Hello, world!")
    }
}
