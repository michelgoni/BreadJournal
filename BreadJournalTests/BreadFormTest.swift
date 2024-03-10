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
        
        let store = TestStore(initialState: BreadFormFeature.State(journalEntry: Entry(id: UUID(.zero)))) {
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
    
    func test_delete_ingredients() async {
        let store = TestStore(
            initialState: BreadFormFeature.State(
                journalEntry: Entry(
                    id: UUID(.zero),
                    ingredients: [
                        Ingredient(
                            id: Ingredient.ID(),
                            ingredient: "Harina"),
                        Ingredient(
                            id: Ingredient.ID(),
                            ingredient: "Agua")
                    ]
                )
            )
        ) {
            BreadFormFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.deleteIngredient(atOffset: [0])) {
            $0.journalEntry.ingredients =  [$0.journalEntry.ingredients[1]]
        }
        
        await store.send(.deleteIngredient(atOffset: [0])) {
            $0.journalEntry.ingredients =  []
        }
    }
    
}
