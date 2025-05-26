//
//  RecuperarPasswordView.swift
//  practica5
//
//  Created by Jesus Abel Gutierrez Calvillo on 20/05/25.
//

import SwiftUI
import FirebaseAuth

struct RecuperarPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var mensaje = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Recover Password")
                .font(.largeTitle)
                .bold()

            TextField("Mail", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Send Reset Email") {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        mensaje = "Error: \(error.localizedDescription)"
                    } else {
                        mensaje = "A recovery email has been sent."
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            Text(mensaje)
                .font(.caption)
                .foregroundColor(.gray)

            Button("Return") {
                dismiss()
            }
        }
        .padding()
    }
}
