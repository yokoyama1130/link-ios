import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("メールアドレス", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("ログイン") {
                login()
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    func login() {
        guard let url = URL(string: "http://localhost:8765/api/login") else { return }

        let parameters = ["email": email, "password": password]
        guard let data = try? JSONSerialization.data(withJSONObject: parameters) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "通信エラー"
                }
                return
            }

            if let json = try? JSONDecoder().decode(LoginResponse.self, from: data),
               json.success {
                DispatchQueue.main.async {
                    authManager.login(with: json.data.token)
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "ログイン失敗"
                }
            }
        }.resume()
    }
}

struct LoginResponse: Codable {
    let success: Bool
    let data: LoginData

    struct LoginData: Codable {
        let token: String
    }
}
#Preview {
    LoginView()
}


