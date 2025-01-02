//
//  FavouritesView.swift
//  Recipe App
//
//  Created by Gaming Lab on 7/11/24.
//

import SwiftUI

struct FavouritesView: View {
    var body: some View {
        NavigationView {
            if Chef.allChefs.isEmpty {
                Text("You haven't saved any recipe to favourites yet.")
                    .padding()
                    .navigationTitle("Featured Chefs")
            } else {
                List(Chef.allChefs, id: \.name) { chef in
                    NavigationLink(destination: ChefDetailView(chef: chef)) {
                        VStack(alignment: .leading) {
                            Text(chef.name)
                                .font(.headline)
                            Text(chef.utubeChannel)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Featured Chefs")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ChefDetailView: View {
    let chef: Chef

    var body: some View {
        List(chef.videos, id: \.caption) { video in
            NavigationLink(destination: VideoDetailView(video: video)) {
                Text(video.caption)
            }
        }
        .navigationTitle(chef.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct VideoDetailView: View {
    let video: Video

    var body: some View {
        VStack {
            Text(video.caption)
                .font(.title2)
                .padding()
            Link("Watch Video", destination: URL(string: video.url)!)
                .padding()
                .foregroundColor(.blue)
                .font(.headline)
        }
        .navigationTitle("Video")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewRecipeView_Preview: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
