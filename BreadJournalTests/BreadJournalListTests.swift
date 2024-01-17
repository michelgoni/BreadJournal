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
    
   
    func test_isloading() async {
        let store = TestStore(initialState: BreadJournalLisFeature.State()) {
            BreadJournalLisFeature()
        }withDependencies: {
            $0.journalListDataManager = .emptyMock()
        }
        
        await store.send(.getEntries) { state in
            state.isLoading = true
        }
        
        await store.receive(\.entriesResponse.success) {
            $0.isLoading = false
        }
    }

}
