import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @State private var selectedImage: UIImage?
    @State private var imagePickerPresented = false
    @State private var title = ""
    @State private var postBody = ""  // ← 修正済み

    var body: some View {
        VStack {
            TextField("タイトル", text: $title)
            TextField("本文", text: $postBody)

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
                // multipart/form-dataで画像と一緒にPOST送信
            }
        }
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }
}


#Preview {
    CreatePostView()
}
