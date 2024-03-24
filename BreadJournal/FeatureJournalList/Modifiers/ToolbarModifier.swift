//
//  ToolbarModifier.swift
//  BreadJournal
//
//  Created by Michel Goñi on 9/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ToolBarFeature {
    @ObservableState
    struct State: Identifiable, Equatable {
        @Presents var filtersDialog: ConfirmationDialogState<Action.Filter>?
        @Presents var destination: Destination.State?
        var entries: IdentifiedArray<UUID, JournalDetailViewFeature.State> = []
        var id: UUID
    }
    
    enum Action {
        case addEntryTapped
        case addEntry(PresentationAction<Destination.Action>)
        case filterEntries
        case filtersDialog(PresentationAction<Filter>)
        case delegate(Delegate)
        enum Filter {
            case filterByFavorites
            case filterByRating
            case filterByDate
        }
        
        @CasePathable
        enum Delegate {
            case addEntryTapped
        }
    }
    
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case add(BreadFormFeature.State)
        }
        
        enum Action {
            case add(BreadFormFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.add, action: \.add) {
                BreadFormFeature()
            }
        }
    }
    @Dependency (\.journalListDataManager.load) var loadEntries
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .filterEntries, .addEntryTapped, .delegate:
                return .none
            
            case .filtersDialog(.presented(.filterByFavorites)):
                let entries = try! JSONDecoder()
                    .decode(
                        IdentifiedArrayOf<Entry>.self,
                        from: loadEntries(.breadEntries)
                    )
                    .sorted { $0.isFavorite && !$1.isFavorite }
                    .map {
                        JournalDetailViewFeature.State(
                            journalEntry: $0,
                            id: $0.id)
                    }
                let final = IdentifiedArrayOf(uniqueElements: entries)
                state.entries = final
                state.filtersDialog = nil
                return .none
            
            case .filtersDialog(.presented(.filterByRating)):
                let entries = try! JSONDecoder()
                    .decode(
                        IdentifiedArrayOf<Entry>.self,
                        from: loadEntries(.breadEntries)
                    )
                    .sorted { $0.rating > $1.rating }
                    .map {
                        JournalDetailViewFeature.State(
                            journalEntry: $0,
                            id: $0.id)
                    }
                let final = IdentifiedArrayOf(uniqueElements: entries)
                state.entries = final
                state.filtersDialog = nil
                return .none
            case .filtersDialog(.presented(.filterByDate)):
                let entries = try! JSONDecoder()
                    .decode(
                        IdentifiedArrayOf<Entry>.self,
                        from: loadEntries(.breadEntries)
                    )
                    .sorted { $0.entryDate > $1.entryDate }
                    .map {
                        JournalDetailViewFeature.State(
                            journalEntry: $0,
                            id: $0.id)
                    }
                let final = IdentifiedArrayOf(uniqueElements: entries)
                state.entries = final
                state.filtersDialog = nil
                return .none
            case .filtersDialog(.dismiss):
                state.filtersDialog = nil
                return .none
            case .addEntry:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.addEntry) {
            Destination()
        }
    }
}

struct ToolbarModifier: ViewModifier {

    @Bindable var store: StoreOf<ToolBarFeature>
    func body(content: Content) -> some View {
        content
            
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        store.send(.addEntryTapped)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                    Spacer()

                    Button {
                        store.send(.filterEntries)
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(.black)
                            .font(.title)
                    }

                }
            }
            
    }
}

extension View {
    func applyToolbar(store: StoreOf<ToolBarFeature>) -> some View {
        self.modifier(ToolbarModifier(store: store))
    }
}

