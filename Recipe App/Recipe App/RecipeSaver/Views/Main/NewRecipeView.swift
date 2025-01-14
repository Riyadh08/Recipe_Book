import SwiftUI
import Firebase
import FirebaseFirestore

struct NewRecipeView: View {
    @State private var recipeName: String = ""
    @State private var chefName: String = ""
    @State private var selectedCategory: Category? = nil // Start with no category selected
    @State private var imageURL: String = ""
    @State private var ingredients: String = ""
    @State private var description: String = ""
    @State private var showSuccessMessage: Bool = false
    @State private var showCategoryErrorMessage: Bool = false // State to show error message for category
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Recipe Name
                    TextField("Enter recipe name", text: $recipeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Chef Name
                    TextField("Enter chef's name", text: $chefName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Category Dropdown
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Category")
                            .font(.headline)
                        
                        Menu {
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("None")
                            }
                            
                            ForEach(Category.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                // Show selected category or default text if none selected
                                Text(selectedCategory?.rawValue ?? "Select Category")
                                    .foregroundColor(selectedCategory == nil ? .gray : .gray)
                                    .fontWeight(.bold)
                                    .padding(.trailing, 10)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(height: 50) // Adjust height to match input fields
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    }.textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Image URL
                    TextField("Enter image URL", text: $imageURL)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Ingredients
                    TextField("Enter ingredients", text: $ingredients)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Description
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    // Show category error message if needed
                    if showCategoryErrorMessage {
                        Text("Please select a category.")
                            .foregroundColor(.red)
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
        guard !recipeName.isEmpty, !chefName.isEmpty, !imageURL.isEmpty, !ingredients.isEmpty, !description.isEmpty else {
            // Show alert for incomplete fields
            return
        }
        
        // Validate if category is selected
        if selectedCategory == nil {
            // Show error message for category
            showCategoryErrorMessage = true
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
            "category": selectedCategory!.rawValue, // Use the rawValue of the selected category
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
        selectedCategory = nil // Reset to no category selected
        imageURL = ""
        ingredients = ""
        description = ""
        showCategoryErrorMessage = false
    }
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView()
    }
}
