//
//  ContentView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
  @StateObject var comicModel: ComicsViewModel
  
  init() {
    let dataManager = ComicDataManager()
    let container = NSPersistentContainer(name: "ComicContainer")
    _comicModel = StateObject(wrappedValue: ComicsViewModel(dataManager: dataManager, container: container))
  }
  
  var body: some View {
    TabView {
      AllComicsView(comicModel: comicModel)
        .tabItem { Label("Explore Comics", systemImage: "book.fill") }
      
      AllCoreComicsView(comicModel: comicModel)
        .tabItem { Label("My Comics", systemImage: "person.fill") }
    }
    .onAppear {
      Task {await comicModel.initializeComics()}
    }
  }
}

#Preview {
  ContentView()
}
