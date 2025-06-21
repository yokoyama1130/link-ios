import Foundation

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var token: String = ""

    func login(with token: String) {
        self.token = token
        self.isLoggedIn = true

        // 必要なら UserDefaults などに保存して永続化も可能
        // UserDefaults.standard.set(token, forKey: "jwtToken")
    }

    func logout() {
        self.token = ""
        self.isLoggedIn = false
    }
}
