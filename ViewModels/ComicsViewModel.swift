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
  
  private let dataManager: ComicDataManager
  private let container: NSPersistentContainer
  
  init(dataManager: ComicDataManager, container: NSPersistentContainer) {
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
    fetchComics()
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
  
  //CORE DATA INTERACTIONS
  
  func fetchComics() {
    let request = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
    
    do {
      let result = try container.viewContext.fetch(request)
      self.savedComics = result
      self.favoriteComicIDs = Set(result.compactMap { Int($0.id)})
    } catch {
      print("Error fetching entities \(error)")
    }
  }
  
  func toggleFavorite(for index: Int) async {
    guard let isCurrentlyFavorite = comicList[index].isFavorite else {
      comicList[index].isFavorite = true
      await addComic(comic: comicList[index])
      return
    }
    if isCurrentlyFavorite {
      comicList[index].isFavorite = false
      removeComic(id: comicList[index].id)
    } else {
      comicList[index].isFavorite = true
      await addComic(comic: comicList[index])
    }
  }
  
  func addComic(comic: Comic) async {
    print("Calling addcomic")
    let context = container.viewContext
    let newComic = ComicEntity(context: context)
    
    newComic.id = Int64(comic.id)
    newComic.title = comic.title
    newComic.year = comic.year
    newComic.month = comic.month
    newComic.day = comic.day
    newComic.transcript = comic.transcript
    newComic.alt = comic.alt
    
    if let explanation = comic.explanation {
      newComic.explanation = explanation
    } else {
      do {
        let parser = HTMLParser()
        let htmlString = try await dataManager.fetchExplanationHTML(for: comic.id)
        let explanation = try parser.parseExplanation(from: htmlString)
        newComic.explanation = explanation
      } catch {
        print("Error fetching HTML string \(error)")
      }
    }
    
    do {
      if let imagePath = try await dataManager.downloadImage(from: comic.img, withID: comic.id) {
        newComic.img = imagePath
      } else {
        print("Failed to download image for comic \(comic.id)")
        newComic.img = nil
      }
    } catch {
      print("Error downloading image for comic \(comic.id): \(error)")
    }
    
    saveData()
  }
  
  func removeComic(id: Int) {
    let request = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
    request.predicate = NSPredicate(format: "id == %d", id)
    
    do {
      let results = try container.viewContext.fetch(request)
      if let existingComic = results.first {
        if let imagePath = existingComic.img {
          deleteImageFile(atPath: imagePath)
        }
        container.viewContext.delete(existingComic)
        saveData()
      }
    } catch {
      print("Error deleting comic: \(error)")
    }
  }
  
  func deleteImageFile(atPath path: String) {
    let fileManager = FileManager.default
    do {
      try fileManager.removeItem(atPath: path)
      print("Successfully deleted image at path \(path).")
    } catch {
      print("Failed to delete image at path \(path): \(error).")
    }
  }
  
  func saveData() {
    do {
      try container.viewContext.save()
    } catch {
      print("Error saving container \(error)")
    }
  }
  
}


extension ComicsViewModel {
  static var preview: ComicsViewModel {
    let model = ComicsViewModel(dataManager: ComicDataManager(), container: NSPersistentContainer(name: ""))
    model.comicList = [
      Comic(month: "7", num: 615, link: "", year: "2009", news: "", safe_title: "Woodpecker", transcript: "A mock comic transcript", alt: "A mock comic alt text", img: "https://imgs.xkcd.com/comics/woodpecker.png", title: "Woodpecker", day: "24"),
      Comic(month: "7", num: 616, link: "", year: "2009", news: "", safe_title: "Squirrel", transcript: "Another mock comic transcript", alt: "Another mock comic alt text", img: "https://imgs.xkcd.com/comics/squirrel.png", title: "Squirrel", day: "25")
    ]
    return model
  }
}
