import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("ホーム画面")
                .font(.largeTitle)
                .bold()

            Text("ようこそ！ログイン成功しました。")
        }
    }
}

#Preview {
    HomeView()
}

