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
        @Presents var destination: Destination.State?
        var entries: IdentifiedArrayOf<JournalDetailViewFeature.State> = []
        var error: BreadJournalError? = nil
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
        
        init(destination: Destination.State? = nil) {
            self.destination = destination
            
            do {
                @Dependency (\.journalListDataManager.load) var loadEntries
                let entries = try JSONDecoder().decode(
                    IdentifiedArrayOf<Entry>.self,
                    from: loadEntries(.breadEntries)
                )
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

        var isEmpty: Bool {
            entries.isEmpty
        }
    }
    
    enum Action {
        case addEntryTapped
        case addEntry(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        case cancelEntry
        case confirmEntryTapped
        case detail(IdentifiedActionOf<JournalDetailViewFeature>)
        
        case filterEntries
        
        enum Alert {
            case error
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
    
    
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        
        EmptyReducer().forEach(\.entries, action: \.detail) {
            JournalDetailViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            
            case .addEntry:
                return .none
            case .addEntryTapped:
                state.destination = .add(
                    BreadFormFeature.State(
                        journalEntry: Entry(
                            id: uuid()
                        )
                    )
                )
                return .none
           
            case .cancelEntry:
                state.destination = nil
                return .none
            case .confirmEntryTapped:
                guard case let .some(.add(editState)) = state.destination else {
                    return .none
                }
                state.entries.append(JournalDetailViewFeature.State(journalEntry: editState.journalEntry, id: editState.journalEntry.id))
                state.destination = nil
                return .none

            case .filterEntries:
                debugPrint("Filtering items")
                return .none
            case .detail:
                return .none
            case .alert:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: \.addEntry) {
          Destination()
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
                                             action: \.detail)) { store in
                        NavigationLink(
                            state: AppFeature.Path.State.detail(
                                JournalDetailViewFeature.State(
                                    journalEntry: store.journalEntry, 
                                    id: store.journalEntry.id)
                            )
                        ) {
                            JournalEntryView(store: store)
                        }
                    }
                }
                
                .padding(.all, 46)
                .loader(isLoading: store.state.isLoading)
                .alert($store.scope(state: \.alert, action: \.alert))
                .applyToolbar(store: store)
                .sheet(item: $store.scope(state: \.destination?.add,
                                          action: \.addEntry.add)) { store in
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
        .emptyPlaceholder(if: store.state.entries.count)
        .applyToolbar(store: store)
        
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
