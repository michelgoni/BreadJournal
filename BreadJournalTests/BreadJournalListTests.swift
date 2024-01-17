//
//  BreadJournalListTests.swift
//  BreadJournalTests
//
//  Created by Michel Goñi on 17/1/24.
//

import ComposableArchitecture
import XCTest

@testable import BreadJournal

@MainActor
final class BreadJournalListTests: XCTestCase {
    
   
    func test_get_empty_entries() async {
        let store = TestStore(initialState: BreadJournalLisFeature.State()) {
            BreadJournalLisFeature()
        }withDependencies: {
            $0.journalListDataManager = .emptyMock()
        }
        
        await store .send(.genEntries) {
            $0.isLoading.toggle()
        }
    }

}
