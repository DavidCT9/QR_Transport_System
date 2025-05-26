//
//  MainView.swift
//  practica5
//
//  Created by Jesus Abel Gutierrez Calvillo on 19/05/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            ContentView()
        } else {
            LoginView()
        }
    }
}

