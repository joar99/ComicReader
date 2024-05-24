//
//  ComicsViewModel.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation
import CoreData

@MainActor
class ComicsViewModel: ObservableObject {
  
  @Published var comicList: [Comic] = []
  @Published var savedComics: [ComicEntity] = []
  @Published var currentIndex: Int = 0
  @Published var latestComicNumber: Int = 0
  @Published var showDetails: Bool = false
  @Published var favoriteComicIDs = Set<Int>()
  
  private let dataManager: ComicDataManagerProtocol
  private let container: NSPersistentContainer
  
  init(dataManager: ComicDataManagerProtocol, container: NSPersistentContainer) {
    self.dataManager = dataManager
    self.container = container
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading CoreData: \(error)")
      } else {
        print("Successfully loaded CoreData")
      }
    }
  }
  
  func initializeComics() async {
    await loadLatestComic()
    await loadComics()
  }
  
  func loadComics() async {
    do {
      let comics = try await dataManager.fetchComics(startingFrom: latestComicNumber, count: 10)
      for var comic in comics {
        comic.isFavorite = self.favoriteComicIDs.contains(comic.id)
        self.comicList.append(comic)
      }
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
  
  
}
