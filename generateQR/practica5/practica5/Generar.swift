//
//  Generar.swift
//  practica5
//
//  Created by Jesus Abel Gutiérrez Calvillo on 30/04/25.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import CoreImage.CIFilterBuiltins

struct Generar: View {
    @State private var claveQR: String = ""
    @State private var mensaje = ""
    
    let context = CIContext()
    let qrFilter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack {
            if !claveQR.isEmpty {
                Image(uiImage: generarImagenQR(clave: claveQR))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                Text("Key: \(claveQR)")
                    .padding()
            }

            Button("Generate QR") {
                generarQRDesdeFirebase()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
            Text(mensaje)
                .font(.caption)
                .foregroundColor(.green)
        }
    }

    func generarImagenQR(clave: String) -> UIImage {
        qrFilter.message = Data(clave.utf8)
        let transform = CGAffineTransform(scaleX: 10, y: 10)

        if let outputImage = qrFilter.outputImage?.transformed(by: transform),
           let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    func generarQRDesdeFirebase() {
        let ref = Database.database().reference().child("Keys")

        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   var datos = snap.value as? [String: Any],
                   let status = datos["status"] as? String,
                   status == "available",
                   let uid = Auth.auth().currentUser?.uid {

                    // Actualizamos la clave en Firebase
                    datos["status"] = "generated"
                    datos["user"] = uid
                    ref.child(snap.key).setValue(datos)

                    // Mostramos el QR
                    self.claveQR = snap.key
                    self.mensaje = "QR code generated correctrly"
                    return
                }
            }

            self.mensaje = "No keys available"
        }
    }
}

