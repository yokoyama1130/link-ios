import Foundation
import UIKit

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var myPosts: [Post] = []

    private var token: String? {
        UserDefaults.standard.string(forKey: "jwt")
    }

    func fetchAllPosts() {
        guard let token = token,
              let url = URL(string: "http://localhost:8765/api/posts.json") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(ResponseData.self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = decoded.data
                    }
                }
            }
        }.resume()
    }

    func fetchMyPosts(myUserId: Int) {
        self.myPosts = self.posts.filter { $0.user_id == myUserId }
    }

    func createPostWithImage(title: String, body: String, image: UIImage?, completion: @escaping () -> Void) {
        guard let token = token,
              let url = URL(string: "http://localhost:8765/api/posts.json") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(title)\r\n".data(using: .utf8)!)

        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"body\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(body)\r\n".data(using: .utf8)!)

        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"media\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }

        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}

struct ResponseData: Codable {
    let data: [Post]
}

