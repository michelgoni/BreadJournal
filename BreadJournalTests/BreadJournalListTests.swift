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
            $0.journalListDataManager = .testValueEmptyMock
        }
        
        await store.send(.getEntries) { state in
            state.isLoading = true
        }
        
        await store.receive(\.entriesResponse.success) {
            $0.isLoading = false
        }
    }
    
    func test_received_error() async {
        let store = TestStore(initialState: BreadJournalLisFeature.State()) {
            BreadJournalLisFeature()
        }withDependencies: {
            $0.journalListDataManager = .testValueErrorMock
        }
        store.exhaustivity = .off
        
        await store.send(.getEntries)
        
        await store.receive(\.entriesResponse.failure) {
            $0.error = .databaseFailure(internalCode: 0)
        }
    }
    
    func test_received_response() async {
        let store = TestStore(initialState: BreadJournalLisFeature.State()) {
            BreadJournalLisFeature()
        }withDependencies: {
            $0.journalListDataManager = .testValueMock
        }
        store.exhaustivity = .off
        
        await store.send(.getEntries)
        
        await store.receive(\.entriesResponse.success) {
            $0.journalEntries[0] = Entry.mock
        }
    }
    
    func test_received_empty_response() async {
        let store = TestStore(initialState: BreadJournalLisFeature.State()) {
            BreadJournalLisFeature()
        }withDependencies: {
            $0.journalListDataManager = .emptyMock()
        }
        store.exhaustivity = .off
        
        await store.send(.getEntries)
        
        await store.receive(\.entriesResponse.success) {
            let array = IdentifiedArray<UUID, Entry>()
            $0.journalEntries = array
        }
    }
}
