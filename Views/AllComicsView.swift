//
//  AllComicsView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct AllComicsView: View {
  
  @ObservedObject var comicModel: ComicsViewModel
  
  var body: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 0) {
        ForEach(Array(comicModel.comicList.enumerated()), id: \.element.num) { index, comic in
          ComicCard(comic: comic)
            .id(comic.num)
            .onTapGesture {
              if comic.explanation == nil {
                Task { await comicModel.fetchExplanation(for: comic.id, at: index) }
              }
              comicModel.showDetails = true
            }
            .sheet(isPresented: $comicModel.showDetails, content: {
              DetailedComicView(comic: comic)
            })
            .onAppear {
              comicModel.currentIndex = index
              if index == comicModel.comicList.count - 1 && index > 0 {
                Task { await comicModel.loadComics() }
              }
            }
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.paging)
    .ignoresSafeArea()
  }
}

struct AllComicsView_Previews: PreviewProvider {
    static var previews: some View {
        AllComicsView(comicModel: .preview)
    }
}
