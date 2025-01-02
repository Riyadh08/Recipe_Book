//
//  RecipeList.swift
//  Recipe App
//
//  Created by Gaming Lab on 10/12/24.
//

import SwiftUI

struct RecipeList: View {
    var recipes: [Recipe]
    
    var body: some View {
        VStack{
            HStack {
//                Text("\(recipes.count)\(recipes.count > 1 ? "recipes" : "recipes")")
//                    .font(.headline)
//                    .fontWeight(.medium)
//                .opacity(0.7)
            
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                ForEach(recipes) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
            .padding(.top)
                
            
        }
        .padding(.horizontal)
       
    }
}

#Preview {
    ScrollView{
        RecipeList(recipes: Recipe.all)
    }
}
   
