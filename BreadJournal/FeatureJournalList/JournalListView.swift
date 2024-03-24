//
//  ContentView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BreadJournalListFeature {
    @ObservableState
    struct State: Equatable {
       
        @Presents var alert: AlertState<Action.Alert>?
        var entries: IdentifiedArrayOf<JournalDetailViewFeature.State> = []
        var filters = ToolBarFeature.State(id: UUID())
        var error: BreadJournalError? = nil
        
        init() {
          
            
            do {
                @Dependency (\.journalListDataManager.load) var loadEntries
                let entries = try JSONDecoder().decode(
                    IdentifiedArrayOf<Entry>.self,
                    from: loadEntries(.breadEntries)
                ).sorted { $0.entryDate > $1.entryDate }
                let values = entries.map {
                    JournalDetailViewFeature.State(
                        journalEntry: $0,
                        id: $0.id)
                }
                let final = IdentifiedArrayOf(uniqueElements: values)
                self.entries = final
                
            } catch is DecodingError {
                alert = .some(AlertState(title: {
                    TextState("Error convirtiendo los datos")
                }))
            } catch {
                alert = .some(AlertState(title: {
                    TextState("Error genérico")
                }))
            }
        }
    }
    
    enum Action {
        case addEntryTapped
       
        case alert(PresentationAction<Alert>)
        case cancelEntry
        case confirmEntryTapped
        case entries(IdentifiedActionOf<JournalDetailViewFeature>)
        case filters(ToolBarFeature.Action)
        
        enum Alert {
            case error
        }
    }
    
    
    @Dependency(\.uuid) var uuid
    @Dependency (\.journalListDataManager.load) var loadEntries
    var body: some ReducerOf<Self> {
        
        Scope(state: \.filters, action: \.filters) {
            ToolBarFeature()
        }
        EmptyReducer().forEach(\.entries, action: \.entries) {
            JournalDetailViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .filters(.addEntryTapped):
                state.filters.destination = .add(
                    BreadFormFeature.State(
                        journalEntry: Entry(
                            id: uuid()
                        )
                    )
                )
                return .none
          
            case .addEntryTapped:
//                state.destination = .add(
//                    BreadFormFeature.State(
//                        journalEntry: Entry(
//                            id: uuid()
//                        )
//                    )
//                )
                return .none
                
            case .cancelEntry:
                
                return .none
            case .confirmEntryTapped:
                guard case let .some(.add(editState)) = state.filters.destination else {
                    return .none
                }
                state.entries.append(JournalDetailViewFeature.State(journalEntry: editState.journalEntry, id: editState.journalEntry.id))
                
                return .none
            case .entries:
                return .none
            case .filters(.filtersDialog(.presented((.filterByRating)))):
                state.entries = state.filters.entries
                return .none
            case .filters(.filtersDialog(.presented((.filterByDate)))):
                state.entries = state.filters.entries
                return .none
            case .filters(.filtersDialog(.presented((.filterByFavorites)))):
                state.entries = state.filters.entries
                return .none
            case .filters(.filtersDialog(.dismiss)):
                
                return .none
            case .filters:
                state.filters.filtersDialog = ConfirmationDialogState(title: {
                    TextState("Filtrar por")
                }, actions: {
                    ButtonState(action: .filterByFavorites) {
                        TextState("Favoritos")
                    }
                    
                    ButtonState(action: .filterByDate) {
                        TextState("Por fecha")
                    }
                    
                    ButtonState(action: .filterByRating) {
                        TextState("Mejor valorados")
                    }
                })
                return .none
            case .alert:
                return .none
            }
        }
        
 
    }
}

struct BreadJournalListView: View {
    
    var columns: [GridItem] {
        switch UIScreen.main.bounds.width {
        case _ where UIScreen.main.bounds.width > 400:
            return [GridItem(.flexible()), GridItem(.flexible())]
        default:
            return [GridItem(.flexible())]
        }
    }
    
    @Bindable var store: StoreOf<BreadJournalListFeature>
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                spacing: 16) {
                    
                    ForEach(store.scope(state: \.entries,
                                        action: \.entries)) { store in
                        NavigationLink(
                            state: AppFeature.Path.State.detail(
                                JournalDetailViewFeature.State(
                                    journalEntry: store.journalEntry,
                                    id: store.journalEntry.id)
                            )
                        ) {
                            let val = $store.scope(
                                state: \.filters.filtersDialog,
                                action: \.filters.filtersDialog
                            )
                            JournalEntryView(store: store)
                        }
                    }
                }
                .padding(.all, 46)
                .alert($store.scope(state: \.alert,
                                    action: \.alert))
                .confirmationDialog(
                    $store.scope(
                        state: \.filters.filtersDialog,
                        action: \.filters.filtersDialog
                    )
                )
            
        }
        .emptyPlaceholder(if: store.state.entries.count,
                          alertPopulated: store.state.alert != nil)
        .applyToolbar(store: self.store.scope(state: \.filters, action: \.filters))
        .sheet(item: $store.scope(state: \.filters.destination?.add,
                                  action: \.filters.addEntry.add)) { store in
            NavigationStack {
                BreadFormView(store: store)
                    .navigationTitle("New journal entry")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                self.store.send(.cancelEntry)
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                self.store.send(.confirmEntryTapped)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            BreadJournalListView(
                store: Store(
                    initialState: BreadJournalListFeature.State(),
                    reducer: {
                        BreadJournalListFeature()
                    }, withDependencies: {
                        $0.journalListDataManager = .previewValue
                    }))
        }
    }
}

#Preview("Empty journal") {
    MainActor.assumeIsolated {
        NavigationStack {
            BreadJournalListView(
                store: Store(
                    initialState: BreadJournalListFeature.State(),
                    reducer: {
                        BreadJournalListFeature()
                    }, withDependencies: {
                        $0.journalListDataManager = .previewEmpty
                    }))
        }
    }
}


#Preview("Decoding error") {
    MainActor.assumeIsolated {
        NavigationStack {
            BreadJournalListView(
                store: Store(
                    initialState: BreadJournalListFeature.State(),
                    reducer: {
                        BreadJournalListFeature()
                    }, withDependencies: {
                        $0.journalListDataManager = .decodingError
                    }))
        }
    }
}
