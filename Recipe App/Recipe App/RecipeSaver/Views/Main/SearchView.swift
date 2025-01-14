import SwiftUI
import Firebase
import FirebaseFirestore

struct SearchView: View {
    @State private var recipeName: String = ""
    @State private var chefName: String = ""
    @State private var selectedCategory: Category? = nil  // Category selection
    
    @State private var filteredRecipes: [Recipe] = []
    @State private var isSearching: Bool = false // Navigation trigger
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Search Criteria")) {
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
                        
                        // Category Dropdown - Aligned Left
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Category")
                                .font(.headline)
                            
                            Menu {
                                // Option to reset category
                                Button(action: {
                                    selectedCategory = nil
                                }) {
                                    Text("None")
                                }
                                
                                // Loop through all categories
                                ForEach(Category.allCases, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        Text(category.rawValue)
                                    }
                                }
                            } label: {
                                HStack {
                                    // Display selected category or default text if none selected
                                    Text(selectedCategory?.rawValue ?? "Select Category")
                                        .foregroundColor(selectedCategory == nil ? .gray : .gray)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 10)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        .frame(height: 50) // Adjust height to match input fields
                                        .frame(maxWidth: .infinity) // Set consistent width for dropdown
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Search Button
                Button(action: searchRecipes) {
                    Text("Search Recipes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding([.leading, .trailing])
                }
                
                // Display filtered recipes or no results message
                if filteredRecipes.isEmpty && !isSearching {
                    Text("No recipes found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                // Navigate to results view if recipes are found
                NavigationLink(
                    destination: AfterSearchView(recipes: filteredRecipes),
                    isActive: $isSearching
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("Search Recipes")
        }
        .navigationViewStyle(.stack)
    }
    
    // Search Recipes function
    private func searchRecipes() {
        let db = Firestore.firestore()
        var query: Query = db.collection("Recipes")
            .whereField("approved", isEqualTo: true) // Ensure only approved recipes are fetched
        
        if !recipeName.isEmpty {
            query = query.whereField("name", isEqualTo: recipeName)
        }
        
        if !chefName.isEmpty {
            query = query.whereField("chefName", isEqualTo: chefName)
        }
        
        if let category = selectedCategory {
            query = query.whereField("category", isEqualTo: category.rawValue)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error searching recipes: \(error.localizedDescription)")
            } else {
                if let documents = snapshot?.documents {
                    self.filteredRecipes = documents.compactMap { document in
                        try? document.data(as: Recipe.self)
                    }
                    self.isSearching = true // Trigger navigation to AfterSearchView
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
