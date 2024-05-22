//
//  ComicCard.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct ComicCard: View {
  
  var comic: Comic
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.white.opacity(0.6))
        .containerRelativeFrame([.horizontal, .vertical])
      
      VStack {
        
        HStack {
          Spacer()
          Button(action: {
            Task {
              //TODO MARK COREDATA FAVORITE
            }
          }) {
            Image(systemName: comic.isFavorite ?? false ? "heart.fill" : "heart")
              .font(.system(size: 40))
          }
        }
        
        if let imageURL = URL(string: comic.img) {
          AsyncImage(url: imageURL) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 340, height: 500)
              .clipped()
          } placeholder: {
            ProgressView()
          }
        } else {
          Text(comic.alt)
        }
      }
    }
  }
}

#Preview {
  ComicCard(comic: Comic.mock)
}
