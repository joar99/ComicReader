//
//  ComicDataManager.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation

class ComicDataManager: ComicDataManagerProtocol {
  
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
    guard let url = URL(string: "https://xkcd.com/info.0.json") else {
      throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(Comic.self, from: data)
  }
  
  func fetchExplanationHTML(for comicID: Int) async throws -> String {
    let urlString = "https://www.explainxkcd.com/wiki/index.php/\(comicID)"
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let htmlString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeContentData)
    }
    return htmlString
  }
  
  func downloadImage(from urlString: String, withID id: Int) async throws -> String? {
    guard let url = URL(string: urlString) else { return nil }
    
    let (imageData, _) = try await URLSession.shared.data(from: url)
    
    let fileManager = FileManager.default
    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = "comic_\(id).png"
    let filePath = documentsDirectory.appendingPathComponent(fileName)
    
    try imageData.write(to: filePath, options: .atomic)
    return filePath.path
  }
}


