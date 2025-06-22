import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: PostViewModel  // ← 修正
    let myUserId = 1

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
    MyPageView(viewModel: PostViewModel())  // ← 修正
}
