//
//  FavoriteComicsStore.swift
//  ComicReader
//
//  Created by Jonas on 24/05/2024.
//

import Foundation

class FavoriteComicsStore: ObservableObject {
  @Published var favoriteComicIDs = Set<Int>()
}
