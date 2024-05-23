//
//  DetailedComicsViewExtension.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI


func fullDateString(year: String, month: String, day: String) -> String? {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy MM dd"
  if let date = dateFormatter.date(from: "\(year) \(month) \(day)") {
    dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
    return dateFormatter.string(from: date)
  }
  return nil
}

@ViewBuilder
func releaseDateView(year: String?, month: String?, day: String?) -> some View {
  if let year = year, let month = month, let day = day,
     let dateString = fullDateString(year: year, month: month, day: day) {
    Text("Release Date: \(dateString)")
  } else {
    Text("Release Date: Unknown")
  }
}


