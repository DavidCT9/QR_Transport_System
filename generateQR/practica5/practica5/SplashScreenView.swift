//
//  SplashScreenView.swift
//  practica5
//
//  Created by Jesus Abel Gutierrez Calvillo on 20/05/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var animate = false

    var body: some View {
        if isActive {
            MainView()
        } else {
            VStack(spacing: 20) {
                Image("MiMovilidadLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(animate ? 1 : 0.6)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 1.0), value: animate)

                Text("QR Transport")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 1.0).delay(0.3), value: animate)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear {
                animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
