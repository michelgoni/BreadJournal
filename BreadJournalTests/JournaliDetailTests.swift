//
//  JournaliDetailTests.swift
//  BreadJournalTests
//
//  Created by Michel Goñi on 7/2/24.
//

import ComposableArchitecture
import XCTest

@testable import BreadJournal

@MainActor
final class JournaliDetailTests: XCTestCase {


    func test_delete_launches_alert() async {
        let store = TestStore(initialState: JournalDetailViewFeature.State(journalEntry: .mock)) {
            JournalDetailViewFeature()
        }
        
        await store .send(.deleteButtonTapped) {
            $0.destination = .alert(.deleteJournalEntry)
            XCTAssertNotNil($0.destination?.alert?.message)
        }
    }
    
    func test_delete_alert_confirm_dismisses() async {
        let didDismiss = LockIsolated(false)
        let store = TestStore(initialState: JournalDetailViewFeature.State(journalEntry: .mock)) {
            JournalDetailViewFeature()
        } withDependencies: {
            $0.dismiss = DismissEffect({
                didDismiss.setValue(true)
            })
        }
        store.exhaustivity = .off
        
        await store.send(.deleteButtonTapped)
        
        await store.send(.destination(.presented(.alert(.confirmDelete)))) {
            $0.destination = nil
        }
    }
}
