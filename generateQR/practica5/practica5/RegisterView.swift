//
//  RegisterView.swift
//  practica5
//
//  Created by Jesus Abel Gutierrez Calvillo on 19/05/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var carrera = ""
    @State private var semestre = ""
    @State private var message = ""

    @State private var mostrarAlerta = false
    @State private var textoAlerta = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create an account")
                    .font(.largeTitle)
                    .bold()

                Group {
                    TextField("Names", text: $nombre)
                    TextField("Lastnames", text: $apellido)
                    TextField("Major", text: $carrera)
                    TextField("Semester", text: $semestre)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

                Group {
                    TextField("Mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

                Button("Sign up") {
                    if camposValidos() {
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            if let error = error {
                                textoAlerta = "Firebase error: \(error.localizedDescription)"
                                mostrarAlerta = true
                            } else if let uid = result?.user.uid {
                                let ref = Database.database().reference()
                                let datos = [
                                    "names": nombre,
                                    "lastname": apellido,
                                    "major": carrera,
                                    "semester": semestre
                                ]
                                ref.child("users").child(uid).setValue(datos)
                                message = "Account created successfully!"
                            }
                        }
                    } else {
                        textoAlerta = "You must complete all fields before continuing."
                        mostrarAlerta = true
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)

                Text(message)
                    .foregroundColor(.gray)
                    .font(.footnote)

                Button("¿You already have an account? Login") {
                    dismiss()
                }
                .padding(.top)
            }
            .padding(.top, 30)
        }
        .alert(isPresented: $mostrarAlerta) {
            Alert(title: Text("Incomplete or Invalid"),
                  message: Text(textoAlerta),
                  dismissButton: .default(Text("OK")))
        }
    }

    func camposValidos() -> Bool {
        return !email.isEmpty &&
               !password.isEmpty &&
               !nombre.isEmpty &&
               !apellido.isEmpty &&
               !carrera.isEmpty &&
               !semestre.isEmpty
    }
}
