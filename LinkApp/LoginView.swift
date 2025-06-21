import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Link ログイン")
                    .font(.title)
                    .bold()

                TextField("メールアドレス", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("パスワード", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    viewModel.login()
                }) {
                    Text("ログイン")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                if !viewModel.message.isEmpty {
                    Text(viewModel.message)
                        .foregroundColor(.gray)
                        .padding()
                }

                // ↓ ここで遷移
                NavigationLink(destination: HomeView(), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

