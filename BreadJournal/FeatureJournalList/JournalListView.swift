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
        @Presents var addNewEntry: BreadFormFeature.State?
        var journalEntries: IdentifiedArrayOf<Entry> = []
        var error: BreadJournalError? = nil
        var isLoading = false
        
        var isEmpty: Bool {
            journalEntries.isEmpty
        }
    }
    
    enum Action: Equatable {
        case addEntryTapped
        case addEntry(PresentationAction<BreadFormFeature.Action>)
        case cancelEntry
        case confirmEntryTapped
        case entriesResponse(TaskResult<IdentifiedArrayOf<Entry>>)
        case getEntries
        case filterEntries
        case saveEntry
    }
    
    @Dependency (\.journalListDataManager.load) var loadEntries
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .addEntry:
                return .none
            case .addEntryTapped:
                state.addNewEntry = BreadFormFeature.State(
                    journalEntry: Entry(
                        id: self.uuid()
                    )
                )
                return .none
            case .cancelEntry:
                state.addNewEntry = nil
                return .none
            case .confirmEntryTapped:
                
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
            case .saveEntry:
                guard let entry = state.addNewEntry?.journalEntry else {
                    return .none
                }
                state.journalEntries.append(entry)
                state.addNewEntry = nil
                return .none
                
            }
        }
        .ifLet(\.$addNewEntry, action: \.addEntry) {
            BreadFormFeature()
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
                }
                .padding(.all, 46)
                .loader(isLoading: store.state.isLoading)
                .onError(error: store.state.error)
                .applyToolbar(store: store)
                .sheet(item: $store.scope(state: \.addNewEntry, action: \.addEntry), content: { store in
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
                })
            
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
