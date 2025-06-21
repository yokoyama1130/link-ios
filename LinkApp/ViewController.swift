import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 🔐 テストログイン
        login(email: "jiro@example.com", password: "password456")
    }

    // 🔽 リクエストボディ
    struct LoginRequest: Codable {
        let email: String
        let password: String
    }

    // 🔽 サーバーから返ってくるユーザーデータ
    struct UserData: Codable {
        let id: Int
        let name: String
        let email: String
        let token: String  // ← トークン追加
    }

    // 🔽 レスポンス全体
    struct LoginResponse: Codable {
        let success: Bool
        let data: UserData?
    }

    // 🔽 ログイン関数
    func login(email: String, password: String) {
        guard let url = URL(string: "http://192.168.1.10:8765/api/login.json") else {
            print("URLが無効")
            return
        }

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
                        print("✅ ログイン成功！名前: \(user.name)")

                        // 🔐 トークン保存
                        UserDefaults.standard.set(user.token, forKey: "authToken")
                        print("トークン保存済み: \(user.token)")

                        // 🔽 保護されたAPIにアクセスしてみる
                        self.fetchUserData()
                    } else {
                        print("❌ ログイン失敗")
                    }
                }
            } catch {
                print("デコード失敗: \(error)")
            }
        }.resume()
    }

    // 🔽 トークン付きAPIアクセス（例：ユーザーデータ取得）
    func fetchUserData() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ トークンが見つかりません")
            return
        }

        guard let url = URL(string: "http://192.168.1.10:8765/api/me.json") else {
            print("URL無効")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("通信エラー: \(error)")
                return
            }

            guard let data = data else {
                print("データなし")
                return
            }

            // ここで必要ならJSONをデコードして表示する
            if let json = String(data: data, encoding: .utf8) {
                print("🎉 APIレスポンス: \(json)")
            } else {
                print("⚠️ 文字列化失敗")
            }
        }.resume()
    }
}
