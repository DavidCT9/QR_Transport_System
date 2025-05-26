//
//  Item.swift
//  practica5
//
//  Created by Jesus Abel Gutiérrez Calvillo on 28/04/25.
//

import SwiftUI

struct Item: View {
    var opcion: Opciones
    var body: some View {
        
        HStack{
            Image(systemName: opcion.imagen).resizable().frame(width: 45, height: 45)
            Text(opcion.opcion).font(.title)
        }
    }
}

#Preview {
    Item(opcion: Opciones(imagen: "globe", opcion: "Leer QR"))
}
