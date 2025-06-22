import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @ObservedObject var viewModel: PostViewModel  // ✅ これだけにする
    @State private var selectedImage: UIImage?
    @State private var imagePickerPresented = false
    @State private var title = ""
    @State private var postBody = ""

    var body: some View {
        VStack {
            TextField("タイトル", text: $title)
                .textFieldStyle(.roundedBorder)

            TextField("本文", text: $postBody)
                .textFieldStyle(.roundedBorder)

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            Button("画像を選択") {
                imagePickerPresented = true
            }

            Button("投稿") {
                print("📤 投稿ボタンが押されました")
                viewModel.createPostWithImage(title: title, body: postBody, image: selectedImage) {
                    print("✅ 投稿完了")
                    title = ""
                    postBody = ""
                    selectedImage = nil
                }
            }

            .padding()
        }
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }
}

#Preview {
    CreatePostView(viewModel: PostViewModel())  // ← ここで作って渡せばOK
}
