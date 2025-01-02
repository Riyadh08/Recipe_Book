import SwiftUI

struct AfterSearchView: View {
    var recipes: [Recipe]
    
    var body: some View {
        ScrollView {
            if recipes.isEmpty {
                Text("No recipes match your search criteria.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
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
        .navigationTitle("Search Results")
    }
}
