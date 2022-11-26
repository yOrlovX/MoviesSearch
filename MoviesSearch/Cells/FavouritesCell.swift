//
//  MovieCell.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 21.11.2022.
//

import SwiftUI

struct FavouritesCell: View {
  @EnvironmentObject var favouritesViewModel: FavouritesViewModel
  let rowData: MovieModel
  
  var body: some View {
    HStack {
      AsyncImage(url: URL(string: rowData.image)) { urlImage in
        urlImage.resizable()
          .scaledToFill()
          .cornerRadius(20)
      } placeholder: {
        ProgressView()
      }
      .frame(width: 75, height: 75)
      VStack(alignment: .leading, spacing: 10) {
        Text(rowData.name)
          .font(.system(size: 15, weight: .bold))
        Text(TextReplacer.replaceHTML(target: rowData.summary ?? "Not found description"))
          .font(.system(size: 12, weight: .regular))
          .lineLimit(4)
      }
      .padding(.vertical, 10)
      Spacer()
      VStack(alignment: .center, spacing: 10) {
        SwiftUI.Image(systemName: "heart.fill")
          .foregroundColor(.red)
          .onTapGesture {
            favouritesViewModel.deleteMovie(id: rowData.id)
            favouritesViewModel.getMovies()
          }
        Text(Formatter.numberFormatter.string(from: NSNumber(value: rowData.rating ?? 0)) ?? "")
          .font(.system(size: 15, weight: .bold))
          .foregroundColor(.gray)
      }
      .padding(.vertical, 10)
    }
  }
}
