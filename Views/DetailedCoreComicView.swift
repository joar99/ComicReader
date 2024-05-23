//
//  DetailedCoreComicView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct DetailedCoreComicView: View {
  
  let dateHandler = DateHandler()
  var comic: ComicEntity
  
  var body: some View {
    ScrollView {
      VStack {
        Text(comic.title ?? "Unknown Title")
          .font(.largeTitle)
          .padding(.bottom, 10)
        
        dateHandler.releaseDateView(year: comic.year, month: comic.month, day: comic.day)
          .padding(.bottom, 10)
        
        localImageView(for: comic.img)
        
        Text("Transcript:")
          .font(.headline)
          .padding(.top, 10)
        
        Text(comic.transcript ?? "No Transcript")
          .padding(.bottom, 10)
        
        Text("Explanation:")
          .font(.headline)
          .padding(.top, 10)
        
        Text(comic.explanation ?? "No Explanation")
        
        Spacer()
      }
    }.padding()
  }
}


