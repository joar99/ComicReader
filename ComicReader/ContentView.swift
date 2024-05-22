//
//  ContentView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct ContentView: View {
  
  
  
    var body: some View {
      TabView {
        AllComicsView()
          .tabItem { Label("Explore Comics", systemImage: "book.fill") }
        
        RoundedRectangle(cornerRadius: 16)
          .foregroundStyle(Color.red)
          .tabItem { Label("My Comics", systemImage: "person.fill") }
      }
    }
}

#Preview {
    ContentView()
}
