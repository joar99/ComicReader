//
//  Comic.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation

struct Comic: Codable, Identifiable {
  var id: Int { num }
  let month: String
  let num: Int
  let link: String
  let year: String
  let news: String
  let safe_title: String
  let transcript: String
  let alt: String
  let img: String
  let title: String
  let day: String
  var explanation: String?
  var isFavorite: Bool? = false
}
