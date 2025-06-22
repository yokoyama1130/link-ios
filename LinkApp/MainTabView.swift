import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = PostViewModel()

    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }

            CreatePostView(viewModel: viewModel)  // ← 渡す！
                .tabItem {
                    Label("投稿", systemImage: "square.and.pencil")
                }

            MyPageView(viewModel: viewModel)
                .tabItem {
                    Label("マイページ", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}
