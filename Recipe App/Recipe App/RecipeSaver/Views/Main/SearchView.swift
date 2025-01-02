import SwiftUI
import Firebase
import FirebaseFirestore

struct SearchView: View {
    @State private var recipeName: String = ""
    @State private var chefName: String = ""
    @State private var category: String = ""
    
    @State private var filteredRecipes: [Recipe] = []
    @State private var isSearching: Bool = false // Navigation trigger
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Search Criteria")) {
                        // Name
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
                    }
                }
                
                Button(action: searchRecipes) {
                    Text("Search Recipes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding([.leading, .trailing])
                }
                
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
        
        if !category.isEmpty {
            query = query.whereField("category", isEqualTo: category)
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
