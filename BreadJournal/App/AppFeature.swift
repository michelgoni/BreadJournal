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
        var breadJournalEntries = BreadJournalListFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case breadJournalEntries(BreadJournalListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.breadJournalEntries, action: \.breadJournalEntries) {
            BreadJournalListFeature()
        }
        Reduce { state, action in
            switch action{
            case .breadJournalEntries:
                return .none
            }
        }
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {}
        enum Action{}
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                    
                }
            }
        }
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    var body: some View {
        NavigationStack {
            BreadJournalListView(store: self.store.scope(state: \.breadJournalEntries, action: \.breadJournalEntries))
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
    }))
}
