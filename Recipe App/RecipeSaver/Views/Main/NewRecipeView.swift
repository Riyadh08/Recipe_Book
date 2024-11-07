//
//  NewRecipeView.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import Foundation
import SwiftUI

struct NewRecipeView: View {
    var body: some View {
        NavigationView{
            Text("New Recipe View")
                .navigationTitle("New Recipe")
            
           }
       
    }
}

struct NewRecipeView_Preview: PreviewProvider{
    static var previews: some View{
        NewRecipeView()
    }
}
