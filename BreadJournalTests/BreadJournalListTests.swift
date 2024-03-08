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
    
    func test_add_entry_tapped() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        }withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.journalListDataManager = .testValueMock
            $0.uuid = .incrementing
        }
       
        var entry = Entry(
                          id: UUID(.zero))
        
        await store.send(.addEntryTapped) {
            $0.destination = .add(BreadFormFeature.State(journalEntry: entry))
        }
        entry.name = "Pan de centeno"
        
        await store.send(.addEntry(.presented(.add(.set(\.journalEntry, entry))))) {
            $0.$destination[case: \.add]?.journalEntry.name = "Pan de centeno"
        }
        
        await store.send(.confirmEntryTapped) {
            $0.entries = [JournalDetailViewFeature.State(journalEntry: entry,
                                                         id: UUID(.zero))]
            $0.destination = nil
        }
    }
    
    func test_cancel_entry() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMock
            $0.uuid = .incrementing
        }
       
        let entry = Entry(id: UUID(0))
        
        await store.send(.addEntryTapped) {
            $0.destination = .add(BreadFormFeature.State(journalEntry: entry))
        }

        await store.send(.cancelEntry) {
            $0.destination = nil
        }
    }

}
