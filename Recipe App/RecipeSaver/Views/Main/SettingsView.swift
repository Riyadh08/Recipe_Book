//
//  SettingsView.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import Foundation
struct SettingsView: View {
    var body: some View {
        NavigationView{
            Text("v1.0.0")
                .navigationTitle("Settings")
            
           }
        
    }
}
struct SettingsView_Preview: PreviewProvider{
    static var previews: some View{
        SettingsView()
    }
}