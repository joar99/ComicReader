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

extension Comic {
  static var mock: Comic {
    return Comic(
      month: "1",
      num: 1,
      link: "",
      year: "2006",
      news: "",
      safe_title: "Barrel - Part 1",
      transcript: "[[A boy sits in a barrel which is floating in an ocean.]]\nBoy: I wonder where I'll float next?\n[[The barrel drifts into the distance. Nothing else can be seen.]]\n{{Alt: Don't we all.}}",
      alt: "Don't we all.",
      img: "https://imgs.xkcd.com/comics/barrel_cropped_(1).jpg",
      title: "Barrel - Part 1",
      day: "1"
    )
  }
}
