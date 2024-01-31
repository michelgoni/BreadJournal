//
//  App.swift
//  BreadJournal
//
//  Created by Michel Goñi on 31/1/24.
//

import ComposableArchitecture
import SwiftUI


@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var breadJournalEntries = BreadJournalLisFeature.State()
    }
    
    enum Action {
        case breadJournalEntries(BreadJournalLisFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.breadJournalEntries, action: \.breadJournalEntries) {
            BreadJournalLisFeature()
        }
        Reduce { state, action in
            switch action{
            case .breadJournalEntries:
                return .none
            }
        }
    }
}

struct AppView: View {
    var body: some View {
        NavigationStack {
            
        }
    }
}

#Preview {
    AppView()
}
