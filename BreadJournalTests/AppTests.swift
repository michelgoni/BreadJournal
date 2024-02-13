//
//  AppTests.swift
//  BreadJournalTests
//
//  Created by Michel Goñi on 13/2/24.
//

import ComposableArchitecture
import XCTest

@testable import BreadJournal

@MainActor
final class AppTests: XCTestCase {

    func tests_save_data() async throws {
        
        let savedData = LockIsolated(Data?.none)
        var entry = Entry.mock
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: { dependencies in
            dependencies.uuid = .incrementing
            dependencies.journalListDataManager = .mock(initialData: try! JSONEncoder().encode([entry]))
            dependencies.journalListDataManager.save = {  @Sendable [dependencies] data, url in
                savedData.setValue(data)
                try await dependencies.journalListDataManager.save(data, url)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.push(id: 0, state: .detail(JournalDetailViewFeature.State(journalEntry: entry))))) {
            $0.path[id: 0] = .detail(.init(journalEntry: entry))
        }
    }

}
