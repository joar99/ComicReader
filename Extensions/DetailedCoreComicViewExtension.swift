//
//  DetailedCoreComicViewExtension.swift
//  ComicReader
//
//  Created by Jonas on 23/05/2024.
//

import SwiftUI

extension DetailedCoreComicView {
  @ViewBuilder
  func localImageView(for imagePath: String?) -> some View {
    if let imagePath = imagePath, let uiImage = UIImage(contentsOfFile: imagePath) {
      Image(uiImage: uiImage)
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 300)
    } else {
      Image(systemName: "photo")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .foregroundColor(.gray)
    }
  }
}
