//
//  ComicDataManager.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation

class ComicDataManager {
  
  func fetchComics(startingFrom startNumber: Int, count: Int) async throws -> [Comic] {
    var comics = [Comic]()
    let endNumber = startNumber + count
    for number in startNumber..<endNumber {
      let urlString = "https://xkcd.com/\(number)/info.0.json"
      guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
      }
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      let comic = try decoder.decode(Comic.self, from: data)
      comics.append(comic)
    }
    return comics
  }
}

