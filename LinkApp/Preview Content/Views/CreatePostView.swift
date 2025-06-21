import SwiftUI

struct CreatePostView: View {
    @StateObject var viewModel = PostViewModel()
    @State private var title = ""
    @State private var content = ""  // ← 修正ここ！

    var body: some View {
        VStack {
            TextField("タイトル", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("本文", text: $content)  // ← ここも合わせて変更
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("投稿") {
                viewModel.createPost(title: title, body: content) {  // ← ここも
                    print("投稿完了")
                }
            }
        }
        .padding()
        .navigationTitle("投稿作成")
    }
}

#Preview {
    CreatePostView()
}
