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
    
    func test_error_decoding_state() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            
            $0.journalListDataManager = .testErrorDecodingMock
        }
        
        XCTAssertTrue((store.state.alert?.title != nil))
    }
    
    func test_filter_shows_modal() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMock
        }
        
        await store.send(.filters(.filterEntries)) {
            $0.filters.filtersDialog = ConfirmationDialogState(title: {
                TextState("Filtrar por")
            }, actions: {
                ButtonState(action: .filterByFavorites) {
                    TextState("Favoritos")
                }
                
                ButtonState(action: .filterByDate) {
                    TextState("Por fecha")
                }
                
                ButtonState(action: .filterByRating) {
                    TextState("Mejor valorados")
                }
            })
        }
    }
    
    func test_filter_cancels_modal() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMock
        }
        store.exhaustivity = .off
        
        await store.send(.filters(.filterEntries))
        await store.send(.filters(.filtersDialog(.dismiss))) {
            $0.filters.filtersDialog = nil
        }
    }
    
    func test_filter_any_action_cancels_modal() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMock
        }
        store.exhaustivity = .off
        
        await store.send(.filters(.filterEntries))
        await store.send(.filters(.filtersDialog(.presented(.filterByDate)))) {
            $0.filters.filtersDialog = nil
        }
    }
    
    func test_filter_filters_favorites() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMockWithFavoriteTrue
        }
        store.exhaustivity = .off
        
        await store.send(.filters(.filterEntries))
        await store.send(.filters(.filtersDialog(.presented(.filterByFavorites)))) {
            
            let favorites = $0.entries.map { $0.journalEntry.isFavorite }
            
            XCTAssertTrue(favorites.first!)
            XCTAssertFalse(favorites.last!)
        }
    }
    
    func test_filter_filters__by_date() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMockWithFavoriteTrue
        }
        store.exhaustivity = .off
        
        await store.send(.filters(.filterEntries))
        await store.send(.filters(.filtersDialog(.presented(.filterByDate)))) {
            let dates = $0.entries.map { $0.journalEntry.entryDate }
            XCTAssertTrue(dates.first! > dates.last!)
        }
    }
    
    func test_filter_filters__by_rating() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.journalListDataManager = .testValueEmptyMockWithFavoriteTrue
        }
        store.exhaustivity = .off
        
        await store.send(.filters(.filterEntries))
        await store.send(.filters(.filtersDialog(.presented(.filterByRating)))) {
            let ratings = $0.entries.map { $0.journalEntry.rating }
            XCTAssertTrue(ratings.first! > ratings.last!)
        }
    }
    
    func test_add_entry_shows_modal() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.journalListDataManager = .testValueMock
            $0.uuid = .incrementing
        }
       
        var entry = Entry(
            id: UUID(.zero)
        )
        
        await store.send(.filters(.addEntryTapped)) {
            $0.filters.destination = .add(BreadFormFeature.State(journalEntry: entry))
        }
    }
    
    func test_add_entry_tapped() async {
        let store = TestStore(initialState: BreadJournalListFeature.State()) {
            BreadJournalListFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.journalListDataManager = .testValueMock
            $0.uuid = .incrementing
        }
       
        var entry = Entry(
            id: UUID(.zero)
        )
        store.exhaustivity = .off
        await store.send(.filters(.addEntryTapped))
        entry.name = "Pan de centeno"
        entry.rating = 2
        
        await store.send(.filters(.addEntry(.presented(.add(.set(\.journalEntry, entry)))))) {
            $0.filters.$destination[case: \.add]?.journalEntry.name = "Pan de centeno"
            $0.filters.$destination[case: \.add]?.journalEntry.rating = 2
        }
        
        await store.send(.confirmEntryTapped) {
            $0.entries = [JournalDetailViewFeature.State(journalEntry: entry,
                                                         id: UUID(.zero))]
            $0.filters.destination = nil
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
        
        await store.send(.filters(.addEntryTapped)) {
            $0.filters.destination = .add(BreadFormFeature.State(journalEntry: entry))
        }

        await store.send(.cancelEntry) {
            $0.filters.destination = nil
        }
    }

}
