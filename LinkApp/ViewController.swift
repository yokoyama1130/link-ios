import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 実行テスト
        login(email: "jiro@example.com", password: "password456")
    }

    // 🔻ここに書く
    struct LoginRequest: Codable {
        let email: String
        let password: String
    }

    struct UserData: Codable {
        let id: Int
        let name: String
        let email: String
    }

    struct LoginResponse: Codable {
        let success: Bool
        let data: UserData?
    }

    func login(email: String, password: String) {
        guard let url = URL(string: "http://192.168.1.xx:8765/api/login.json") else { return }
        // ↑ localhost じゃなく MacのローカルIP（後述）に変更！

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = LoginRequest(email: email, password: password)

        do {
            request.httpBody = try JSONEncoder().encode(loginData)
        } catch {
            print("エンコード失敗: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("通信エラー: \(error)")
                return
            }

            guard let data = data else {
                print("データなし")
                return
            }

            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    if loginResponse.success, let user = loginResponse.data {
                        print("ログイン成功！名前: \(user.name)")
                    } else {
                        print("ログイン失敗")
                    }
                }
            } catch {
                print("デコード失敗: \(error)")
            }
        }.resume()
    }
}
