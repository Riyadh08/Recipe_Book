//
//  LoadingView.swift
//  Recipe App
//
//  Created by Biduit on 13/12/24.
//


import SwiftUI
import FirebaseAuth

struct LoadingView: View {
    @State private var isLoading: Bool = true
    @State private var isLoggedIn: Bool? = nil

    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView("Checking authentication...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    
                }
                .onAppear(perform: checkAuthentication)
            } else {
                if isLoggedIn == true {
                    ContentView() // Navigate to ContentView if user is logged in
                } else {
                    LoginView() // Navigate to LoginView if user is not logged in
                }
            }
        }
    }

    private func checkAuthentication() {
        // Check Firebase Auth state
        if let user = Auth.auth().currentUser {
            print("User logged in: \(user.email ?? "Unknown Email")")
            isLoggedIn = true
        } else {
            print("No user is logged in.")
            isLoggedIn = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
}
