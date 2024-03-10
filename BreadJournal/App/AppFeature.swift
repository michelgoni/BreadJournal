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
    
    @Dependency(\.journalListDataManager.save) var save
    
    var body: some ReducerOf<Self> {
        Scope(state: \.breadJournalEntries, action: \.breadJournalEntries) {
            BreadJournalListFeature()
        }
        Reduce { state, action in
            switch action {
            case let .path(.element(id: id, .detail(.delegate(delegateAction)))):
                guard case let .some(.detail(detailState)) = state.path[id: id] else { return .none}
                switch delegateAction {
                    
                case let .entryUpdated(updatedEntry):
                    state.breadJournalEntries.entries[id: updatedEntry.id] = JournalDetailViewFeature.State(journalEntry: updatedEntry, id: updatedEntry.id)
                    return .none
                case .deleteJournalEntry:
                    state.breadJournalEntries.entries.remove(id: detailState.journalEntry.id)
                    return .none
                }
              
            case .breadJournalEntries(_):
                return .none
            case .path:
              return .none
           
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }

        Reduce { state, action in
            return .run { [entries = state.breadJournalEntries.entries] _ in
                let values = entries.map{$0.journalEntry}
                try await save(JSONEncoder().encode(values), .breadEntries)
            }
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

#Preview("Edición") {
    var entry = Entry.mock
    entry.name = "Receta EDITADA"
    
    return AppView(
        store: Store(
            initialState: AppFeature.State(
                path: StackState(
                    [.detail(
                        JournalDetailViewFeature.State(
                            destination: JournalDetailViewFeature.Destination.State.edit(
                                BreadFormFeature.State(
                                    journalEntry: entry)
                            ),
                            journalEntry: entry, id: UUID()))])
            ),
            reducer: {
                AppFeature()
            }))
}


#Preview("Detalles") {
    AppView(store: Store(initialState: AppFeature.State(path: StackState([.detail(JournalDetailViewFeature.State(journalEntry: .mock, id: UUID()))])),
                         reducer: {
        AppFeature()
    }))
}


#Preview("Inicio") {
    AppView(store: Store(initialState: AppFeature.State(), 
                         reducer: {
        AppFeature()
    }))
}
