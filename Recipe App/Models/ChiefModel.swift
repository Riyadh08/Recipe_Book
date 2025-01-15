//
//  ChefModel.swift
//  JSONParsing
//
//  Created by Kaniz Fatema on 27/11/24.
//

import Foundation

struct Chef: Codable {
    let name: String
    let utubeChannel: String
    let videos: [Video]
    
    static let allChefs: [Chef] = Bundle.main.decode(file: "Chefs.json")
    static let sampleChef: Chef = allChefs[0]
}

struct Video: Codable {
    let caption: String
    let url: String
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}
