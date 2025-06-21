import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = PostViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("投稿一覧")
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    HomeView()
}

