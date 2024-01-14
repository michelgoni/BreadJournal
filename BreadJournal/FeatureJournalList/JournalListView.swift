//
//  ContentView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer

struct BreadJournalLisFeature {
    
    struct State {
        var journalEntries: IdentifiedArrayOf<Entry> = []
        var error: BreadJournalError? = nil
        var loading = false
    }
    
    enum Action {
        case addEntry
        case cancelEntry
        case entriesResponse(TaskResult<IdentifiedArrayOf<Entry>>)
        case genEntries
        case filterEntries
        
    }
    
    
    var body: some ReducerOf<Self> {
        @Dependency (\.journalListDataManager.load) var loadEntries
        Reduce { state, action in
            switch action {
            case .addEntry:
                return .none
            case .cancelEntry:
                return .none
            case .genEntries:
                state.loading.toggle()
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
                state.journalEntries = data
                return .none
            case let .entriesResponse(.failure(error)):
                debugPrint(error)
                return .none
            case .filterEntries:
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

    let store: StoreOf<BreadJournalLisFeature>
    
    var body: some View {
        WithViewStore(self.store,
                      observe: \.journalEntries) { viewStore in
            NavigationStack {
                if viewStore.isEmpty {
                    EmptyJournalView()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: columns,
                            spacing: 16) {
                                ForEach(viewStore.state) { entry in
                                    JournalEntryView.init(entry: entry)
                                }
                            }
                            .padding(.all, 46)
                    }
                }
            } 
            .navigationTitle("Bread journal")
                .applyToolbar(viewStore: viewStore)
                .task {
                    viewStore.send(.genEntries)
                }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            BreadJournalListView(
                store: Store(
                    initialState: BreadJournalLisFeature.State(),
                    reducer: {
                        BreadJournalLisFeature()
                            ._printChanges()
                    }, withDependencies: {
                        $0.journalListDataManager = .previewValue
                    }))
            
        }
    }
}
