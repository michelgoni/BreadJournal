//
//  BreadFormTest.swift
//  BreadJournalTests
//
//  Created by Michel Goñi on 8/2/24.
//

import ComposableArchitecture
import XCTest

@testable import BreadJournal

@MainActor
final class BreadFormTest: XCTestCase {
    
    func test_add_ingredients() async {
        
        let store = TestStore(initialState: BreadFormFeature.State(journalEntry: Entry(id: Entry.ID()))) {
            BreadFormFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addIngredientTapped("")) {
            $0.journalEntry.ingredients = [
                                Ingredient(
                                    id: Ingredient.ID(UUID(0))
                                )
                            ]
        }
        
    }
    
}
