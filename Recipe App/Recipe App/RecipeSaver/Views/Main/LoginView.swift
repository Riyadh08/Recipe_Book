import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSuccess: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var isAdmin: Bool = false // Track if the user is an admin

    var body: some View {
        Group {
            if isLoggedIn {
                // Navigate to the appropriate view based on admin status
                if isAdmin {
                    AdminView() // Navigate to AdminView for admin users
                } else {
                    ContentView() // Navigate to ContentView for regular users
                }
            } else {
                NavigationView {
                    VStack {
                        Form {
                            Section(header: Text("Log In")) {
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                if showPassword {
                                    TextField("Password", text: $password)
                                        .textContentType(.password)
                                } else {
                                    SecureField("Password", text: $password)
                                        .textContentType(.password)
                                }
                                
                                Toggle("Show Password", isOn: $showPassword)
                                    .padding(.top, 4)
                            }
                        }
                        
                        Button(action: loginAction) {
                            Text("Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding([.leading, .trailing])
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        NavigationLink(destination: SignupView()) {
                            Text("Don't have an account?")
                                .foregroundColor(.blue)
                                .padding(.top)
                        }
                    }
                    .navigationTitle("Log In")
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(isSuccess ? "Success" : "Error"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .navigationViewStyle(.stack)
            }
        }
    }
    
    private func loginAction() {
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "All fields are required.", success: false)
            return
        }
        
        // Firebase Auth: Log in user
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showAlert(message: error.localizedDescription, success: false)
                return
            }
            
            // Login successful, check if the user is an admin
            if self.email == "admin@gmail.com" {
                isAdmin = true
            } else {
                isAdmin = false
            }
            
            // Set logged in state to true
            isLoggedIn = true
        }
    }
    
    private func showAlert(message: String, success: Bool) {
        alertMessage = message
        isSuccess = success
        showAlert = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
