//
//  RatingTests.swift
//  BreadJournalTests
//
//  Created by Michel Goñi on 10/3/24.
//

import ComposableArchitecture
import XCTest

@testable import BreadJournal

@MainActor

final class RatingTests: XCTestCase {

    func test_rating() async {
        
        let entry = Entry(rating: 2,
                          id: UUID(0))
        
        let store = TestStore(
            initialState: JournalDetailViewFeature.State(
                journalEntry: entry,
                id: UUID(0)),
            reducer: {
                JournalDetailViewFeature()
            })
        
        await store.send(.ratingTapped(.ratingTapped(3))) {
            $0.ratingState.rating = 3
        }
    }

}
