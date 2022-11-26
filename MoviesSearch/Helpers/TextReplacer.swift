//
//  TextReplacer.swift
//  MoviesSearch
//
//  Created by Yaroslav Orlov on 25.11.2022.
//

import Foundation

struct TextReplacer {
  static func replaceHTML(target: String) -> String {
    let replacements = [
      ("<p>", ""),
      ("<b>", ""),
      ("</b>", ""),
      ("</p>", ""),
      ("<i>", ""),
      ("</i>", "")
    ]
    
    var newText = target
    for (searchString, replacement) in replacements {
      newText = newText.replacingOccurrences(of: searchString, with: replacement)
    }
    return newText
  }
}
