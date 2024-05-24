//
//  ComicsViewModelExtension.swift
//  ComicReader
//
//  Created by Jonas on 23/05/2024.
//

import Foundation
import CoreData

extension ComicsViewModel {
  static var mock: ComicsViewModel {
    let mockModel = ComicsViewModel(dataManager: ComicDataManager(), favoriteStore: FavoriteComicsStore())
    mockModel.comicList = [
      Comic(month: "7", num: 615, link: "", year: "2009", news: "", safe_title: "Woodpecker", transcript: "A mock comic transcript", alt: "A mock comic alt text", img: "https://imgs.xkcd.com/comics/woodpecker.png", title: "Woodpecker", day: "24"),
      Comic(month: "7", num: 616, link: "", year: "2009", news: "", safe_title: "Squirrel", transcript: "Another mock comic transcript", alt: "Another mock comic alt text", img: "https://imgs.xkcd.com/comics/squirrel.png", title: "Squirrel", day: "25")
    ]
    return mockModel
  }
}
