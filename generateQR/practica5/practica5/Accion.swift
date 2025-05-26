//
//  Accion.swift
//  practica5
//
//  Created by Jesus Abel Gutiérrez Calvillo on 28/04/25.
//

import SwiftUI

struct Accion: View {
    var opc: String
    var body: some View {
        if opc == "Generar QR" {
            Generar()
        } else {
            Generar()
        }
    }
}

#Preview {
    Accion(opc: "Generar QR")
}
