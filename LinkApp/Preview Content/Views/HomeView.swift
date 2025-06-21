import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = PostViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title).bold()
                    Text(post.body)
                }
            }
            .navigationTitle("ホーム")
            .onAppear {
                viewModel.fetchAllPosts()
            }
        }
    }
}
#Preview {
    HomeView()
}
