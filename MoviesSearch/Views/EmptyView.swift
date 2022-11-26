//
//  EmptyView.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 21.11.2022.
//

import SwiftUI

struct EmptyView: View {
  @Binding var text: String
  
  var body: some View {
    VStack {
      Text("\(text) :Not found😒")
        .font(.headline)
        .padding()
      ProgressView()
    }
  }
}
