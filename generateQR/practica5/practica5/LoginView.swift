//
//  LoginView.swift
//  practica5
//
//  Created by Jesus Abel Gutierrez Calvillo on 19/05/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct LoginView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Enter") {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            print("Login error: \(error.localizedDescription)")
                        } else {
                            isLoggedIn = true
                        }
                    }
                }

                
                NavigationLink("¿Don't have an account? Sign up") {
                    RegisterView()
                }
                
                NavigationLink("¿Forgot your password?") {
                    RecuperarPasswordView()
                }

                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
    }
}

