//
//  ContentView.swift
//  LinkApp
//
//  Created by yokoyan on 2025/06/21.
//

import SwiftUI

struct ContentView: View {
    // AppStorage でトークンを保持していれば再起動後も維持される
    @AppStorage("jwtToken") var jwtToken: String = ""

    var body: some View {
        if jwtToken.isEmpty {
            LoginView()
        } else {
            MainTabView()
        }
    }
}


#Preview {
    ContentView()
}
