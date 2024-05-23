//
//  ComicCard.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct ComicCard: View {
  
  var comicModel: ComicsViewModel
  var comic: Comic
  var index: Int
  
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
              await comicModel.toggleFavorite(for: index)
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

struct ComicCard_Previews: PreviewProvider {
    static var previews: some View {
      ComicCard(comicModel: .preview, comic: Comic.mock, index: 1)
    }
}
