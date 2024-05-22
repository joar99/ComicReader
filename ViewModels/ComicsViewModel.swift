//
//  ComicsViewModel.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation

@MainActor
class ComicsViewModel: ObservableObject {
  
  @Published var comicList: [Comic] = []
  @Published var currentIndex: Int = 0
  @Published var latestComicNumber: Int = 0
  @Published var showDetails: Bool = false
  
  private let dataManager: ComicDataManager
  
  init(dataManager: ComicDataManager) {
    self.dataManager = dataManager
  }
  
  func initializeComics() async {
    await loadLatestComic()
    await loadComics()
  }
  
  func loadComics() async {
    do {
      let comics = try await dataManager.fetchComics(startingFrom: latestComicNumber, count: 10)
      self.comicList.append(contentsOf: comics)
      latestComicNumber -= 10
    } catch {
      print("Error fetching comics: \(error)")
    }
  }
  
  
  func loadLatestComic() async {
    do {
      let latestComic = try await dataManager.fetchLatestComic()
      latestComicNumber = latestComic.num
      print(latestComicNumber)
    } catch {
      print("Error fetching the latest comic: \(error)")
    }
  }
  
  
}

extension ComicsViewModel {
  static var preview: ComicsViewModel {
    let model = ComicsViewModel(dataManager: ComicDataManager())
    model.comicList = [
      Comic(month: "7", num: 615, link: "", year: "2009", news: "", safe_title: "Woodpecker", transcript: "A mock comic transcript", alt: "A mock comic alt text", img: "https://imgs.xkcd.com/comics/woodpecker.png", title: "Woodpecker", day: "24"),
      Comic(month: "7", num: 616, link: "", year: "2009", news: "", safe_title: "Squirrel", transcript: "Another mock comic transcript", alt: "Another mock comic alt text", img: "https://imgs.xkcd.com/comics/squirrel.png", title: "Squirrel", day: "25")
    ]
    return model
  }
}
