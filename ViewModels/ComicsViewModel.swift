//
//  ComicsViewModel.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation
import Combine

@MainActor
class ComicsViewModel: ObservableObject {
  
  @Published var comicList: [Comic] = []
  @Published var currentIndex: Int = 0
  @Published var latestComicNumber: Int = 0
  @Published var showDetails: Bool = false
  @Published var favoriteStore: FavoriteComicsStore
  
  private let dataManager: ComicDataManagerProtocol
  var favoriteTogglePublisher = PassthroughSubject<Comic, Never>()
  
  init(dataManager: ComicDataManagerProtocol, favoriteStore: FavoriteComicsStore) {
    self.dataManager = dataManager
    self.favoriteStore = favoriteStore
  }
  
  func initializeComics() async {
    await loadLatestComic()
    await loadComics()
  }
  
  func loadComics() async {
    do {
      let comics = try await dataManager.fetchComics(startingFrom: latestComicNumber, count: 20)
      for var comic in comics {
        comic.isFavorite = self.favoriteStore.favoriteComicIDs.contains(comic.id)
        self.comicList.append(comic)
      }
      latestComicNumber -= 20
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
  
  func fetchExplanation(for comicID: Int, at index: Int) async {
    let parser = HTMLParser()
    do {
      let htmlString = try await dataManager.fetchExplanationHTML(for: comicID)
      let explanation = try parser.parseExplanation(from: htmlString)
      self.comicList[index].explanation = explanation
    } catch {
      print("Error fetching explanation: \(error)")
      self.comicList[index].explanation = "Failed to load explanation"
    }
  }
  
  func toggleFavorite(for index: Int) async {
    let comic = comicList[index]
    favoriteTogglePublisher.send(comic)
    comicList[index].isFavorite?.toggle()
    print("toggleFavorites on: \(comic.title)")
  }
  
}
