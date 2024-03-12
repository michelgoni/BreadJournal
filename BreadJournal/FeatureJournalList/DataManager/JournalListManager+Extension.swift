//
//  JournalListManager+Extension.swift
//  BreadJournal
//
//  Created by Michel Goñi on 18/1/24.
//

import ComposableArchitecture
import Foundation

extension JournalListManager: TestDependencyKey {
    
    static let testErrorDecodingMock = Self.decodingErrorMock()
    static let testValueMock = Self.mockTest()
    static let testValueEmptyMock = Self.emptyMockTest()
    static let testValueErrorMock = Self.errorMockTest()
    
    static func mockTest(initialData: Data? = nil) -> Self {
        let data = LockIsolated(try? JSONEncoder().encode([Entry.mockTest]))
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
    
    static func emptyMockTest(initialData: Data? = nil) -> Self {
        let data = LockIsolated(try? JSONEncoder().encode([Entry].self ()))
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
    
    static func errorMockTest(initialData: Data? = nil) -> Self {
        struct FileNotFound: Error {}
        
      return Self(
        load: { _ in
          
            throw FileNotFound()
        },
        save: { _ , _ in}
      )
    }
    
    static func errorDecodingMockTest(initialData: Data? = nil) -> Self {
       
      return Self(
        load: { _ in
            let mockError = DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Decoding error",
                    underlyingError: nil)
            )

            throw mockError
        },
        save: { _ , _ in}
      )
    }
}

