//
//  practica5App.swift
//  practica5
//
//  Created by Jesus Abel Gutiérrez Calvillo on 28/04/25.
//

import SwiftUI
import Firebase

@main
struct practica5App: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

