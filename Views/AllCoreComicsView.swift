//
//  AllCoreComicsView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct AllCoreComicsView: View {
  
  @ObservedObject var coreModel: CoreComicViewModel
  
    var body: some View {
      NavigationStack {
        List(coreModel.savedComics, id: \.self) { comic in
          NavigationLink(destination: DetailedCoreComicView(comic: comic)) {
            VStack {
              Text(comic.title ?? "Unknown Title")
            }
          }
        }
        .onAppear {
          coreModel.fetchComics()
        }
        .navigationTitle("Saved Comics")
      }
    }
}

struct AllCoreComicsView_Previews: PreviewProvider {
    static var previews: some View {
        AllComicsView(comicModel: .mock)
    }
}
