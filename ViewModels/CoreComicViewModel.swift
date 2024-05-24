//
//  CoreComicViewModel.swift
//  ComicReader
//
//  Created by Jonas on 24/05/2024.
//

import Foundation
import CoreData
import Combine

class CoreComicViewModel: ObservableObject {
  
  @Published var savedComics: [ComicEntity] = []
  //VARIABLE TO REFERENCE FAVORITES SOMEHOW TODO
  
  private var cancellables = Set<AnyCancellable>()
  private let container: NSPersistentContainer
  private let dataManager: ComicDataManagerProtocol
  
  init(dataManager: ComicDataManagerProtocol, container: NSPersistentContainer) {
    self.dataManager = dataManager
    self.container = container
    //FAVORITE VARIABLES SET TODO
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading CoreData stores: \(error)")
      } else {
        print("Successfully loaded CoreData")
      }
    }
  }
  
  func subscribeToFavoriteToggles(publisher: PassthroughSubject<Comic, Never>) {
    publisher
      .sink { [weak self] comic in
        Task { [weak self] in
          guard let self = self else { return }
          print("Received comic in subscription: \(comic.title)")
          if let isFavorite = comic.isFavorite {
            if isFavorite {
              self.removeComic(id: comic.id)
            } else {
              await self.addComic(comic: comic)
            }
          }
        }
      }
      .store(in: &cancellables)
    }
  
  func fetchComics() {
    let request = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
    do {
      let result = try container.viewContext.fetch(request)
      self.savedComics = result
      //SET ORIGINAL COMIC AS FAVORITE TODO
    } catch {
      print("Error fetching entities \(error)")
    }
  }
  
  func addComic(comic: Comic) async {
    print("Calling addcomic on \(comic.title)")
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
