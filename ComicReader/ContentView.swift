//
//  ContentView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
  let dataManager: ComicDataManagerProtocol
  let container: NSPersistentContainer
  let favoriteStore: FavoriteComicsStore
  
  @StateObject var comicModel: ComicsViewModel
  @StateObject var coreModel: CoreComicViewModel
  
  init() {
    let dataManager = ComicDataManager()
    let container = NSPersistentContainer(name: "ComicContainer")
    let favoriteStore = FavoriteComicsStore()
    
    self.dataManager = dataManager
    self.container = container
    self.favoriteStore = favoriteStore
    
    _comicModel = StateObject(wrappedValue: ComicsViewModel(dataManager: dataManager, favoriteStore: favoriteStore))
    _coreModel = StateObject(wrappedValue: CoreComicViewModel(dataManager: dataManager, container: container, favoriteStore: favoriteStore))
  }
  
  var body: some View {
    TabView {
      AllComicsView(comicModel: comicModel)
        .tabItem { Label("Explore Comics", systemImage: "book.fill") }
      
      AllCoreComicsView(coreModel: coreModel)
        .tabItem { Label("My Comics", systemImage: "person.fill") }
    }
    .onAppear {
      coreModel.subscribeToFavoriteToggles(publisher: comicModel.favoriteTogglePublisher)
      Task {
        coreModel.fetchComics()
        await comicModel.initializeComics()
      }
    }
  }
}

#Preview {
  ContentView()
}
