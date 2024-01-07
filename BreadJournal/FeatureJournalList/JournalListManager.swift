//
//  JournalListManager.swift
//  BreadJournal
//
//  Created by Michel Goñi on 7/1/24.
//

import ComposableArchitecture
import Foundation

struct JournalListManager {
    var load: @Sendable (URL) throws -> Data
    var save: @Sendable (Data, URL) throws -> Void
}

extension JournalListManager: DependencyKey {
    
    static let liveValue = Self(
        load: { url in try Data(contentsOf: url) },
        save: { data, url in try data.write(to: url) }
    )
    
    static let previewValue = Self.mock()
    
    
    static func mock(initialData: Data? = nil) -> Self {
        let data = LockIsolated(try? JSONEncoder().encode([Entry.mock, Entry.mock2]))
      return Self(
        load: { _ in
          guard let data = data.value
          else {
            struct FileNotFound: Error {}
            throw FileNotFound()
          }
          return data
        },
        save: { newData, _ in data.setValue(newData) }
      )
    }
}

extension DependencyValues {
  var journalListDataManager: JournalListManager {
    get { self[JournalListManager.self] }
    set { self[JournalListManager.self] = newValue }
  }
}
