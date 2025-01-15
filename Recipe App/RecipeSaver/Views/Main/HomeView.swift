import SwiftUI
import Firebase
import FirebaseFirestore

struct HomeView: View {
    @State private var recipes: [Recipe] = [] // State to store fetched recipes

    var body: some View {
        NavigationView {
            ScrollView {
                if recipes.isEmpty {
                    Text("Loading recipes...")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Use LazyVGrid to display recipes
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                        ForEach(recipes) { recipe in
                            NavigationLink(destination: DetailView(recipe: recipe)) {
                                RecipeCard(recipe: recipe) // Using your existing RecipeCard view
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Welcome to Recipe App")
            .onAppear {
                fetchRecipes() // Fetch recipes when the view appears
            }
        }
        .navigationViewStyle(.stack)
    }

    // Function to fetch approved recipes from Firestore
    private func fetchRecipes() {
        let db = Firestore.firestore()
        
        // Fetch the recipes collection from Firestore where 'approved' is true
        db.collection("Recipes")
            .whereField("approved", isEqualTo: true) // Only fetch approved recipes
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching recipes: \(error.localizedDescription)")
                } else {
                    // Process the fetched documents
                    if let documents = snapshot?.documents {
                        // Map the documents to Recipe objects
                        self.recipes = documents.compactMap { document in
                            try? document.data(as: Recipe.self)
                        }
                    }
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
