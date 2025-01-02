import SwiftUI
import Firebase
import FirebaseAuth

struct SignupView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSuccess: Bool = false
    @State private var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if isLoggedIn {
                ContentView() // Navigate to ContentView if the user is logged in
            } else {
                NavigationView {
                    VStack {
                        Form {
                            Section(header: Text("Account Information")) {
                                TextField("Username", text: $username)
                                    .textContentType(.username)
                                    .autocapitalization(.none)
                                
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            Section(header: Text("Password")) {
                                if showPassword {
                                    TextField("Password", text: $password)
                                        .textContentType(.newPassword)
                                } else {
                                    SecureField("Password", text: $password)
                                        .textContentType(.newPassword)
                                }
                                
                                if showPassword {
                                    TextField("Confirm Password", text: $confirmPassword)
                                } else {
                                    SecureField("Confirm Password", text: $confirmPassword)
                                }
                                
                                Toggle("Show Password", isOn: $showPassword)
                                    .padding(.top, 4)
                            }
                            
                            Section(header: Text("Additional Information")) {
                                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                                    .environment(\.locale, Locale(identifier: "en_US")) // Adjust to your region if needed
                            }
                        }
                        
                        Button(action: signupAction) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding([.leading, .trailing])
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Already have an account?")
                                .foregroundColor(.blue)
                                .padding(.top)
                        }
                    }
                    .navigationTitle("Sign Up")
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
    
    private func signupAction() {
        // Validate inputs
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            showAlert(message: "All fields are required.", success: false)
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.", success: false)
            return
        }
        
        // Firebase Auth: Create user
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showAlert(message: error.localizedDescription, success: false)
                return
            }
            
            guard let user = authResult?.user else {
                showAlert(message: "Failed to create user. Please try again.", success: false)
                return
            }
            
            // Save additional user data to Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "username": username,
                "email": email,
                "dateOfBirth": dateOfBirth,
                "uid": user.uid
            ]
            
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    showAlert(message: error.localizedDescription, success: false)
                } else {
                    // Successfully created account and saved data
                    isLoggedIn = true
                }
            }
        }
    }
    
    private func showAlert(message: String, success: Bool) {
        alertMessage = message
        isSuccess = success
        showAlert = true
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
