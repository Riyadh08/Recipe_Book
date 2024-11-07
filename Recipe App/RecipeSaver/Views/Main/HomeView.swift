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
            Text("My Recipes")
                .navigationTitle("My Recipes")
            
           }
       
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
