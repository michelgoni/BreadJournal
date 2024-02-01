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
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.breadJournalEntries, action: \.breadJournalEntries) {
            BreadJournalListFeature()
        }
        Reduce { state, action in
            switch action{
            case .path:
                return .none
            case .breadJournalEntries:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case detail(JournalDetailViewFeature.State)
        }
        enum Action{
            case detail(JournalDetailViewFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                JournalDetailViewFeature()
            }
        }
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            BreadJournalListView(store: store.scope(state: \.breadJournalEntries, action: \.breadJournalEntries))
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.detail) {
                    JournalDetailView(store: store)
                }
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), 
                         reducer: {
        AppFeature()
    }))
}
