import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var message = ""
    @Published var isLoggedIn = false  // ← 追加！

    func login() {
        guard let url = URL(string: "http://localhost:8765/api/login.json") else {
            self.message = "URLが不正です"
            return
        }

        let parameters = [
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "通信エラー: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.message = "データがありません"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let success = json["success"] as? Bool {
                        if success {
                            self.message = "ログイン成功！"
                            self.isLoggedIn = true  // ← 成功時にフラグを立てる
                        } else {
                            self.message = "ログイン失敗"
                        }
                    }
                } catch {
                    self.message = "JSON解析エラー"
                }
            }
        }.resume()
    }
}
