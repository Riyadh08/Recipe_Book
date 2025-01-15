import SwiftUI
import FirebaseAuth

struct LoadingView: View {
    @State private var isLoading: Bool = true
    @State private var isLoggedIn: Bool? = nil
    @State private var isAdmin: Bool = false // Flag to check if the user is admin

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
                    if isAdmin {
                        AdminView() // Navigate to AdminView if user is admin
                    } else {
                        ContentView() // Navigate to ContentView if user is logged in but not admin
                    }
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
            // Check if the logged-in user is admin
            if user.email == "admin@gmail.com" {
                isAdmin = true // Set isAdmin flag to true for admin user
            }
        } else {
            print("No user is logged in.")
            isLoggedIn = false
        }

        // Delay for 1 second before updating the UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
