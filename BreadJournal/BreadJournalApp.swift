//
//  BreadJournalApp.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct BreadJournalApp: App {
    var body: some Scene {
        WindowGroup {
            BreadJournalListView( 
                store: Store(
                    initialState: BreadJournalListFeature.State(),
                    reducer: {
                        BreadJournalListFeature()
                    }))
        }
    }
}
