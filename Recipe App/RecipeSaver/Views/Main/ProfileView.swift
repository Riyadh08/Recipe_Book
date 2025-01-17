import SwiftUI
import FirebaseAuth
import Firebase

struct ProfileView: View {
    @State private var showEditProfileView = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var confirmDelete = false
    @State private var isLoading = true
    @State private var username = ""
    @State private var email = ""
    @State private var dateOfBirth = ""

    var body: some View {
        Group {
            if isLoading {
                LoadingView() // Show loading screen
            } else {
                NavigationView {
                    VStack(spacing: 20) {
                        // Profile Information
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Username: \(username)")
                                .font(.headline)
                            Text("Email: \(email)")
                                .font(.subheadline)
                            Text("Date of Birth: \(dateOfBirth)")
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding([.leading, .trailing])

                        // Edit Profile Button
                        Button(action: {
                            showEditProfileView = true
                        }) {
                            Text("Edit Profile")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding([.leading, .trailing])
                        .sheet(isPresented: $showEditProfileView) {
                            EditProfileView()
                        }

                        // Logout Button
                        Button(action: logout) {
                            Text("Logout")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding([.leading, .trailing])

                        // Delete Account Button
                        Button(action: {
                            confirmDelete = true
                        }) {
                            Text("Delete Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding([.leading, .trailing])
                        .alert(isPresented: $confirmDelete) {
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete"), action: deleteAccount),
                                secondaryButton: .cancel()
                            )
                        }

                        Spacer()
                    }
                    .navigationTitle("Profile")
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationViewStyle(.stack)
            }
        }
        .onAppear(perform: fetchUserData)
    }

    private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "User not logged in.", success: false)
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                showAlert(message: error.localizedDescription, success: false)
            } else if let data = snapshot?.data() {
                self.username = data["username"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                if let dob = data["dateOfBirth"] as? Timestamp {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.dateOfBirth = formatter.string(from: dob.dateValue())
                }
                self.isLoading = false
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            alertTitle = "Logged Out"
            alertMessage = "You have successfully logged out."
            showAlert = true
            // Navigate to LoginView after logout
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Replace ContentView with LoginView in navigation
                let window = UIApplication.shared.windows.first
                window?.rootViewController = UIHostingController(rootView: LoginView())
                window?.makeKeyAndVisible()
            }
        } catch {
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }

        user.delete { error in
            if let error = error {
                alertTitle = "Error"
                alertMessage = error.localizedDescription
            } else {
                alertTitle = "Account Deleted"
                alertMessage = "Your account has been successfully deleted."
            }
            showAlert = true
        }
    }

    private func showAlert(message: String, success: Bool) {
        alertMessage = message
        alertTitle = success ? "Success" : "Error"
        showAlert = true
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
