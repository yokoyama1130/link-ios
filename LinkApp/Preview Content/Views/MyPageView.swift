import SwiftUI

struct MyPageView: View {
    @StateObject var viewModel = PostViewModel()
    let myUserId = 1 // JWTのsubの値と一致させる

    var body: some View {
        List(viewModel.myPosts) { post in
            VStack(alignment: .leading) {
                Text(post.title).bold()
                Text(post.body)
            }
        }
        .navigationTitle("マイページ")
        .onAppear {
            viewModel.fetchAllPosts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.fetchMyPosts(myUserId: myUserId)
            }
        }
    }
}
#Preview {
    MyPageView()
}
