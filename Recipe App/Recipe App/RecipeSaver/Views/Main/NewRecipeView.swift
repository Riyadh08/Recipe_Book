import SwiftUI
import Firebase
import FirebaseFirestore

struct NewRecipeView: View {
    @State private var recipeName: String = ""
    @State private var chefName: String = ""
    @State private var category: String = ""
    @State private var imageURL: String = ""
    @State private var age: String = ""
    @State private var ingredients: String = ""
    @State private var description: String = ""
    
    @State private var showSuccessMessage: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Recipe Name
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recipe Name")
                            .font(.headline)
                        TextField("Enter recipe name", text: $recipeName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Chef Name
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Chef Name")
                            .font(.headline)
                        TextField("Enter chef's name", text: $chefName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Category
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Category")
                            .font(.headline)
                        TextField("Enter category", text: $category)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Image URL
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Image URL")
                            .font(.headline)
                        TextField("Enter image URL", text: $imageURL)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Age
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Age (e.g., years for recipe)")
                            .font(.headline)
                        TextField("Enter age", text: $age)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ingredients")
                            .font(.headline)
                        TextField("Enter ingredients", text: $ingredients)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                    
                    // Save Recipe Button
                    Button(action: saveRecipe) {
                        Text("Add Recipe")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding([.leading, .trailing])
                    }
                    .padding(.top)
                    
                    // Success Message
                    if showSuccessMessage {
                        Text("Recipe Added Successfully!")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding()
                    }
                }
            }
            .navigationTitle("Add Recipe")
        }
        .navigationViewStyle(.stack)
    }
    
    private func saveRecipe() {
        // Validate inputs
        guard !recipeName.isEmpty, !chefName.isEmpty, !category.isEmpty, !imageURL.isEmpty, !age.isEmpty, !ingredients.isEmpty, !description.isEmpty else {
            // Show alert for incomplete fields
            return
        }
        
        // Firestore reference
        let db = Firestore.firestore()
        
        // Prepare recipe data
        let recipeData: [String: Any] = [
            "name": recipeName,
            "image": imageURL,
            "ingredients": ingredients,
            "directions": description,
            "category": category,
            "datePublished": Date().formatted(date: .numeric, time: .omitted),
            "chefName": chefName,
            "approved": false  // Default to false
        ]
        
        // Add recipe to Firestore
        db.collection("Recipes").addDocument(data: recipeData) { error in
            if let error = error {
                // Handle error (Show alert with error message)
                print("Error adding recipe: \(error.localizedDescription)")
            } else {
                // Handle success (Show success message)
                print("Recipe added successfully!")
                
                // Reset fields
                resetFields()
                
                // Show success message
                showSuccessMessage = true
                
                // Hide success message after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSuccessMessage = false
                }
            }
        }
    }

    // Reset all fields after recipe is added
    private func resetFields() {
        recipeName = ""
        chefName = ""
        category = ""
        imageURL = ""
        age = ""
        ingredients = ""
        description = ""
    }
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView()
    }
}
