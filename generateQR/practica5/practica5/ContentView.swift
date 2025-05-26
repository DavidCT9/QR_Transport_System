//
//  ContentView.swift
//  practica5
//
//  Created by Jesus Abel Gutiérrez Calvillo on 28/04/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    let opciones = [
        //Opciones(imagen: "camera", opcion: "Leer QR"),
        Opciones(imagen: "ticket", opcion: "Generate QR")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List(opciones, id: \.opcion) { opcione in
                    NavigationLink {
                        Accion(opc: opcione.opcion)
                    } label: {
                        Item(opcion: opcione)
                    }
                }
                
                // Acceso al perfil
                NavigationLink(destination: PerfilView()) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
            .navigationTitle("List of options")
        }
    }
}

#Preview {
    ContentView()
}

