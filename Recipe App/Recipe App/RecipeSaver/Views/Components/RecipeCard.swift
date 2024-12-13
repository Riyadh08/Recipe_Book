import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
        ZStack {
            // Background Image
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            
            // Centered Text
            Text(recipe.name)
                .font(.title2) // Changed to a larger font size
                .foregroundColor(.white)
                .shadow(color: .black, radius: 3, x: 0, y: 0)
                .multilineTextAlignment(.center) // Center-align text
                .lineLimit(2) // Allow max 2 lines
                .truncationMode(.tail) // Truncate with ellipsis if needed
                .padding()
        }
        .frame(width: 160, height: 217, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

#Preview {
    RecipeCard(recipe: Recipe.all[0])
}
