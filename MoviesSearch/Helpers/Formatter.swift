//
//  Formatter.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 25.11.2022.
//

import Foundation

struct Formatter {
  static var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    return formatter
  }
}
