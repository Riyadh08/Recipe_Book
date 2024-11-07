//
//  CategoriesVIew.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import Foundation


import SwiftUI

struct CategoriesVIew: View {
    var body: some View {
        NavigationView{
            Text("Categories")
                .navigationTitle("Categories")
            
           }
       
    }
}

struct Categories_Previews: PreviewProvider{
    static var previews: some View{
        CategoriesVIew()
    }
}
