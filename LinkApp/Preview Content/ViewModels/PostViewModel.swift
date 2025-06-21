import Foundation

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var myPosts: [Post] = []

    private let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTc1MTEzODY2OH0.uBw86aG_c0g7ypHaxyEUl0NWT4WxZn89edSfIsmydDM"

    func fetchAllPosts() {
        guard let url = URL(string: "http://localhost:8765/api/posts.json") else { return }

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

    func createPost(title: String, body: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost:8765/api/posts.json") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["title": title, "body": body]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
}

struct ResponseData: Codable {
    let data: [Post]
}

