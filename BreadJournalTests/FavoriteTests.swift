//
//  FavoriteTests.swift
//  BreadJournalTests
//
//  Created by Michel Goñi on 7/3/24.
//

import ComposableArchitecture
import XCTest

@testable import BreadJournal

@MainActor
final class FavoriteTests: XCTestCase {
    
    func test_favorite_true() async {
        
        let entry = Entry(isFavorite: false,
                          id: UUID(0))
        
        let store = TestStore(
            initialState: JournalDetailViewFeature.State(
                journalEntry: entry,
                id: UUID(0)),
            reducer: {
                JournalDetailViewFeature()
            })
        
        await store.send(.favoriteTapped(.buttonFavoriteTapped)) {
            $0.favoritingState.isFavorite = true
        }
        
    }
    
    func test_favorite_false() async {
        
        var entry = Entry(isFavorite: true,
                          id: UUID(0))
        
        let store = TestStore(
            initialState: JournalDetailViewFeature.State(
                journalEntry: entry,
                id: UUID(0)),
            reducer: {
                JournalDetailViewFeature()
            })
        
        await store.send(.favoriteTapped(.buttonFavoriteTapped)) {
            $0.favoritingState.isFavorite = false
        }
        
    }
    
}
