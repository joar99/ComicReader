//
//  DetailedComicView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct DetailedComicView: View {
  
  let dateHandler = DateHandler()
  var comic: Comic
  
    var body: some View {
      ScrollView {
        VStack {
          Text(comic.title)
            .font(.largeTitle)
            .padding(.bottom, 10)
          
          dateHandler.releaseDateView(year: comic.year, month: comic.month, day: comic.day)
          
          Text("Transcript:")
            .font(.headline)
            .padding(.top, 10)
          Text(comic.transcript)
            .padding(.bottom, 10)
          
          Text("Explanation:")
            .font(.headline)
            .padding(.top, 10)
          
          Text(comic.explanation ?? "No Explanation")
          
          Spacer()
        }
      }
      .padding()
    }
}

#Preview {
  DetailedComicView(comic: .mock)
}
