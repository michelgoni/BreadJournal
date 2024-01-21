//
//  URL.swift
//  BreadJournal
//
//  Created by Michel Goñi on 7/1/24.
//

import Foundation

extension URL {
  static let breadEntries = Self.documentsDirectory.appending(component: "breadEntries.json")
}
