import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: PostViewModel  // ← 修正

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.title)
                        .font(.headline)

                    Text(post.body)
                        .font(.body)

                    if let path = post.media_path,
                       let url = URL(string: "http://localhost:8765" + path) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            case .failure:
                                Text("画像の読み込みに失敗しました")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("ホーム")
        }
        .onAppear {
            viewModel.fetchAllPosts()
        }
    }
}

#Preview {
    HomeView(viewModel: PostViewModel())  // ← 修正
}
