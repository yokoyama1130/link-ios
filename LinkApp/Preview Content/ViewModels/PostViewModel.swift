import Foundation

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    let token = "ここにJWTトークンを貼る"

    func fetchPosts() {
        guard let url = URL(string: "http://localhost:8765/api/posts.json") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    struct ApiResponse: Codable {
                        let success: Bool
                        let data: [Post]
                    }

                    let decoded = try JSONDecoder().decode(ApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.posts = decoded.data
                    }
                } catch {
                    print("JSON decode error:", error)
                }
            } else {
                print("Network error:", error ?? "Unknown error")
            }
        }.resume()
    }
}
