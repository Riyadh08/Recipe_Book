//
//  HomeView.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import Foundation

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                RecipeList(recipes: Recipe.all)
                
            }
            .navigationTitle("My Recipes")
            
           }
        .navigationViewStyle(.stack)
       
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
