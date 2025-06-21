import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var selectedImage: UIImage?
    @State private var imagePickerPresented = false
    @State private var title = ""
    @State private var postBody = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("タイトル", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("本文", text: $postBody)
                .textFieldStyle(RoundedBorderTextFieldStyle())

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
                viewModel.createPostWithImage(title: title, body: postBody, image: selectedImage) {
                    // 投稿完了後の処理
                    title = ""
                    postBody = ""
                    selectedImage = nil
                    print("投稿完了")
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .navigationTitle("投稿作成")
    }
}


#Preview {
    CreatePostView()
}
