//
//  ComicDataManagerProtocol.swift
//  ComicReader
//
//  Created by Jonas on 23/05/2024.
//

import Foundation

protocol ComicDataManagerProtocol {
  func fetchComics(startingFrom startNumber: Int, count: Int) async throws -> [Comic]
  func fetchLatestComic() async throws -> Comic
  func fetchExplanationHTML(for comicID: Int) async throws -> String
  func downloadImage(from urlString: String, withID id: Int) async throws -> String?
}
