//
//  FavouritesView.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import Foundation
import SwiftUI

struct FavouritesView: View {
    var body: some View {
        NavigationView{
            Text("You have't saved any recipe to favourites yet.")
                .padding()
                .navigationTitle("Favourites")
            
           }
        .navigationViewStyle(.stack)
       
    }
}

struct NewRecipeView_Preview: PreviewProvider{
    static var previews: some View{
        FavouritesView()
    }
}
