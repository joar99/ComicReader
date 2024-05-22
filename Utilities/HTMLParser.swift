//
//  HTMLParser.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import Foundation
import SwiftSoup

struct HTMLParser {
  
  func parseExplanation(from htmlString: String) throws -> String {
    let doc = try SwiftSoup.parse(htmlString)
    var explanationText = ""
    if let explanationHeading = try doc.select("h2:has(span#Explanation)").first() {
      var nextSibling = try explanationHeading.nextElementSibling()
      while nextSibling?.tagName() != "h2" {
        if nextSibling?.tagName() == "p" {
          explanationText += try nextSibling!.text() + "\n\n"
        }
        nextSibling = try nextSibling?.nextElementSibling()
      }
    } else {
      throw URLError(.cannotDecodeContentData)
    }
    return explanationText.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
