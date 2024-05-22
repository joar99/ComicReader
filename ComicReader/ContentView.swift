//
//  ContentView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject var comicModel: ComicsViewModel
  
  init() {
    let dataManager = ComicDataManager()
    _comicModel = StateObject(wrappedValue: ComicsViewModel(dataManager: dataManager))
  }
  
    var body: some View {
      TabView {
        AllComicsView(comicModel: comicModel)
          .tabItem { Label("Explore Comics", systemImage: "book.fill") }
        
        RoundedRectangle(cornerRadius: 16)
          .foregroundStyle(Color.red)
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
