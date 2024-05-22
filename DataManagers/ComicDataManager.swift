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
    let endNumber = startNumber - count + 1
    for number in (endNumber...startNumber).reversed() {
      let urlString = "https://xkcd.com/\(number)/info.0.json"
      print("Fetching comic at URL: \(urlString)")
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
  
  func fetchLatestComic() async throws -> Comic {
      let url = URL(string: "https://xkcd.com/info.0.json")!
      let (data, _) = try await URLSession.shared.data(from: url)
      return try JSONDecoder().decode(Comic.self, from: data)
  }
}


