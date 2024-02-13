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
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    } 

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
