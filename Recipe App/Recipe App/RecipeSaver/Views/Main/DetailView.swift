import SwiftUI

struct DetailView: View {
    var recipe: Recipe // Selected recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Recipe Image
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(
                            Text("Loading Image...")
                                .foregroundColor(.gray)
                        )
                }
                
                // Recipe Name
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                // Chef Name
                Text("By \(recipe.chefName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Category
                Text("Category: \(recipe.category.capitalized)")
                    .font(.headline)
                
                // Date Published
                Text("Published on: \(recipe.datePublished)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Ingredients
                Text("Ingredients")
                    .font(.headline)
                Text(recipe.ingredients)
                    .font(.body)
                    .padding(.bottom)
                
                Divider()
                
                // Directions
                Text("Directions")
                    .font(.headline)
                Text(recipe.directions)
                    .font(.body)
                    .padding(.bottom)
            }
            .padding() // Padding for the content
        }
        .background(Color(.systemGroupedBackground)) // Background color
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
