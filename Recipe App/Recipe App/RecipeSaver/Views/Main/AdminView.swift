import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AdminView: View {
    @State private var recipes: [Recipe] = []
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle = ""

    let columns: [GridItem] = [
        GridItem(.flexible()), // Adjust grid to have flexible columns
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView { // Ensure this is wrapped in a NavigationView
            VStack {
                Text("Admin Page")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                if recipes.isEmpty {
                    Text("No unapproved recipes found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Grid for recipe cards and actions
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(recipes) { recipe in
                            VStack {
                                // Recipe card content (use your existing RecipeCard view)
                                RecipeCard(recipe: recipe)
                                
                                // NavigationLink for DetailView
                                NavigationLink(destination: DetailView(recipe: recipe)) {
                                    Text("View Details")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }

                                // Buttons below each recipe card
                                HStack {
                                    Button(action: {
                                        approveRecipe(recipe)
                                    }) {
                                        Text("Approve")
                                            .padding(5)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }

                                    Button(action: {
                                        deleteRecipe(recipe)
                                    }) {
                                        Text("Delete")
                                            .padding(5)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding([.top, .bottom])
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // Logout Button
                Button(action: logout) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding([.leading, .trailing, .bottom])
                }
            }
            .onAppear {
                fetchUnapprovedRecipes()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // Fetch unapproved recipes from Firestore
    private func fetchUnapprovedRecipes() {
        let db = Firestore.firestore()

        db.collection("Recipes")
            .whereField("approved", isEqualTo: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    alertMessage = "Error fetching recipes: \(error.localizedDescription)"
                    alertTitle = "Error"
                    showAlert = true
                } else {
                    self.recipes = snapshot?.documents.compactMap { document in
                        var recipe = try? document.data(as: Recipe.self)
                        // Set Firestore document ID locally
                        recipe?.firestoreId = document.documentID
                        return recipe
                    } ?? []
                }
            }
    }

    // Approve a recipe (only update 'approved' field)
    private func approveRecipe(_ recipe: Recipe) {
        guard let firestoreId = recipe.firestoreId else { return }
        let db = Firestore.firestore()

        // Update the 'approved' field in Firestore
        db.collection("Recipes")
            .document(firestoreId)
            .updateData(["approved": true]) { error in
                if let error = error {
                    alertMessage = "Error approving recipe: \(error.localizedDescription)"
                    alertTitle = "Error"
                    showAlert = true
                } else {
                    // Remove the recipe from the current list (locally)
                    recipes.removeAll { $0.id == recipe.id }
                    alertMessage = "Recipe approved successfully!"
                    alertTitle = "Success"
                    showAlert = true
                }
            }
    }

    // Delete a recipe from Firestore
    private func deleteRecipe(_ recipe: Recipe) {
        guard let firestoreId = recipe.firestoreId else { return }
        let db = Firestore.firestore()

        db.collection("Recipes")
            .document(firestoreId)
            .delete() { error in
                if let error = error {
                    alertMessage = "Error deleting recipe: \(error.localizedDescription)"
                    alertTitle = "Error"
                    showAlert = true
                } else {
                    // Remove the recipe from the current list (locally)
                    recipes.removeAll { $0.id == recipe.id }
                    alertMessage = "Recipe deleted successfully!"
                    alertTitle = "Success"
                    showAlert = true
                }
            }
    }

    // Logout the admin
    private func logout() {
        do {
            try Auth.auth().signOut()
            alertTitle = "Logged Out"
            alertMessage = "You have successfully logged out."
            showAlert = true

            // Navigate to LoginView after logout
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
}
