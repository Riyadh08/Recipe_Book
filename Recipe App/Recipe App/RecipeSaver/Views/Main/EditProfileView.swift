import SwiftUI
import Firebase
import FirebaseAuth

struct EditProfileView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode // To dismiss the view after update
    
    var body: some View {
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
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "en_US"))
                }
            }
            
            Button(action: updateProfile) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.leading, .trailing])
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle("Edit Profile")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear(perform: fetchCurrentUserData)
    }

    private func fetchCurrentUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
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
                    self.dateOfBirth = dob.dateValue()
                }
            }
        }
    }

    private func updateProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "dateOfBirth": dateOfBirth
        ]
        
        db.collection("users").document(userId).updateData(userData) { error in
            if let error = error {
                showAlert(message: error.localizedDescription, success: false)
            } else {
                showAlert(message: "Profile updated successfully!", success: true)
                
                // Dismiss the EditProfileView and return to ProfileView
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the sheet
                }
            }
        }
    }

    private func showAlert(message: String, success: Bool) {
        alertMessage = message
        alertTitle = success ? "Success" : "Error"
        showAlert = true
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
