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
        var journalEntries: IdentifiedArrayOf<Entry> = []
        var error: BreadJournalError? = nil
        var isLoading = false
        
        init(destination: Destination.State? = nil) {
            self.destination = destination
        }
        
        var isEmpty: Bool {
            journalEntries.isEmpty
        }
    }
    
    enum Action {
        case addEntryTapped
        case addEntry(PresentationAction<Destination.Action>)
        case cancelEntry
        case confirmEntryTapped
        case entriesResponse(TaskResult<IdentifiedArrayOf<Entry>>)
        case getEntries
        case filterEntries
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
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .addEntry:
                return .none
            case .addEntryTapped:
                state.destination = .add(
                    BreadFormFeature.State(
                        journalEntry: Entry(
                            id: Entry.ID(
                                self.uuid()
                            )
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
                state.journalEntries.append(editState.journalEntry)
                state.destination = nil
                
                return .none
            case .getEntries:
                state.isLoading.toggle()
                return .run { send in
                    await send (.entriesResponse(
                        TaskResult {
                            try JSONDecoder().decode(
                                IdentifiedArrayOf<Entry>.self,
                                from: loadEntries(.breadEntries)
                            )
                        })
                    )
                }
                
            case let .entriesResponse(.success(data)):
                state.isLoading.toggle()
                state.journalEntries = data
                return .none
            case let .entriesResponse(.failure(error)):
                state.isLoading.toggle()
                state.error = .underlying(error)
                return .none
            case .filterEntries:
                debugPrint("Filtering items")
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
                    ForEach(store.state.journalEntries) { entry in
                        NavigationLink(state: AppFeature.Path.State.detail(JournalDetailViewFeature.State(journalEntry: entry))) {
                            JournalEntryView.init(entry: entry)
                        }
                    }
                    .emptyPlaceholder(if: store.state.journalEntries.count)
                }
                .padding(.all, 46)
                .loader(isLoading: store.state.isLoading)
                .onError(error: store.state.error)
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
        .task {
            store.send(.getEntries)
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
                            ._printChanges()
                    }, withDependencies: {
                        $0.journalListDataManager = .previewValue
                    }))
            
        }
    }
}
