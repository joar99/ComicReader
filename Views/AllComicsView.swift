//
//  AllComicsView.swift
//  ComicReader
//
//  Created by Jonas on 22/05/2024.
//

import SwiftUI

struct AllComicsView: View {
    var body: some View {
      ScrollView(.vertical) {
        LazyVStack(spacing: 0) {
          ForEach(0..<100) { i in
            ZStack {
              Rectangle()
                .fill(Color.blue.opacity(0.6))
                .containerRelativeFrame([.horizontal, .vertical])
              Text("Comic \(i+1)")
                .font(.title)
                .bold()
            }
          }
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.paging)
      .ignoresSafeArea()
    }
}

#Preview {
    AllComicsView()
}
