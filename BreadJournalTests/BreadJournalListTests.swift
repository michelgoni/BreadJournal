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
    
    func test_add_entry_is_ok() async {
        let clock = TestClock()
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        }withDependencies: {
            $0.journalListDataManager = .testValueMock
            $0.uuid = .incrementing
        }
       
        var entry = Entry(id: Entry.ID(UUID(0)))
        
        await store.send(.addEntryTapped) {
            $0.destination = .add(BreadFormFeature.State(journalEntry: entry))
        }
        entry.name = "Pan de centeno"
        
        await store.send(.addEntry(.presented(.add(.set(\.journalEntry, entry))))) {
            $0.$destination[case: \.add]?.journalEntry.name = "Pan de centeno"
        }
        
        await store.send(.confirmEntryTapped) {
            $0.destination = nil
            $0.journalEntries = [entry]
        }
    }
    
    
//    func test_isloading() async {
//        let store = TestStore(initialState: BreadJournalListFeature.State()) {
//            BreadJournalListFeature()
//        }withDependencies: {
//            $0.journalListDataManager = .testValueEmptyMock
//            $0.uuid = .incrementing
//        }
//        
//        await store.send(.getEntries) { state in
//            state.isLoading = true
//        }
//        
//        await store.receive(\.entriesResponse.success) {
//            $0.isLoading = false
//        }
//    }
//    
//    func test_received_error() async {
//        let store = TestStore(initialState: BreadJournalListFeature.State()) {
//            BreadJournalListFeature()
//        }withDependencies: {
//            $0.journalListDataManager = .testValueErrorMock
//        }
//        store.exhaustivity = .off
//        
//        await store.send(.getEntries)
//        
//        await store.receive(\.entriesResponse.failure) {
//            $0.error = .databaseFailure(internalCode: 0)
//        }
//    }
//    
//    func test_received_response() async {
//        let store = TestStore(initialState: BreadJournalListFeature.State()) {
//            BreadJournalListFeature()
//        }withDependencies: {
//            $0.journalListDataManager = .testValueMock
//        }
//        store.exhaustivity = .off
//        
//        await store.send(.getEntries)
//        
//        await store.receive(\.entriesResponse.success) {
//            $0.journalEntries[0] = Entry.mock
//        }
//    }
//    
//    func test_received_empty_response() async {
//        let store = TestStore(initialState: BreadJournalListFeature.State()) {
//            BreadJournalListFeature()
//        }withDependencies: {
//            $0.journalListDataManager = .emptyMock()
//        }
//        store.exhaustivity = .off
//        
//        await store.send(.getEntries)
//        
//        await store.receive(\.entriesResponse.success) {
//            let array = IdentifiedArray<UUID, Entry>()
//            $0.journalEntries = array
//        }
//    }
}
