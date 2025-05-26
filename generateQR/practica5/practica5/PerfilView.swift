//
//  PerfilView.swift
//  practica5
//
//  Created by Jesus Abel Gutierrez Calvillo on 19/05/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct PerfilView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    @State private var nombre = ""
    @State private var apellido = ""
    @State private var carrera = ""
    @State private var semestre = ""
    @State private var mensaje = ""

    var body: some View {
        Form {
            Section(header: Text("User information")) {
                TextField("Names", text: $nombre)
                TextField("Last names", text: $apellido)
                TextField("Major", text: $carrera)
                TextField("Semester", text: $semestre)
            }

            Button("Save changes") {
                guardarCambios()
            }

            if !mensaje.isEmpty {
                Text(mensaje)
                    .font(.caption)
                    .foregroundColor(.green)
            }

            Section {
                Button("Logout") {
                    isLoggedIn = false
                    try? Auth.auth().signOut()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            cargarDatos()
        }
    }

    func cargarDatos() {
        guard let uid = Auth.auth().currentUser?.uid else {
            mensaje = "Could not get user data. User not logged in."
            return
        }

        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let datos = snapshot.value as? [String: Any] {
                self.nombre = datos["names"] as? String ?? ""
                self.apellido = datos["lastname"] as? String ?? ""
                self.carrera = datos["major"] as? String ?? ""
                self.semestre = datos["semester"] as? String ?? ""
            }
        }
    }

    func guardarCambios() {
        guard let uid = Auth.auth().currentUser?.uid else {
            mensaje = "Could not save changes. User not logged in."
            return
        }

        let ref = Database.database().reference().child("users").child(uid)
        let datosActualizados = [
            "names": nombre,
            "lastname": apellido,
            "major": carrera,
            "semester": semestre
        ]
        ref.setValue(datosActualizados) { error, _ in
            if let error = error {
                mensaje = "Could not save changes: \(error.localizedDescription)"
            } else {
                mensaje = "Changes saved successfully."
            }
        }
    }
}

