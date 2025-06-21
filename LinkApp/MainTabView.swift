import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }

            CreatePostView()
                .tabItem {
                    Label("投稿", systemImage: "square.and.pencil")
                }

            MyPageView()
                .tabItem {
                    Label("マイページ", systemImage: "person.circle")
                }
        }
    }
}
#Preview {
    MainTabView()
}
