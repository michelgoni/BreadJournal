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
    
    struct State: Equatable {
        var journalEntries: IdentifiedArrayOf<Entry> = []
        var error: BreadJournalError? = nil
        var isLoading = false
    }
    
    enum Action: Equatable {
        case addEntry
        case cancelEntry
        case entriesResponse(TaskResult<IdentifiedArrayOf<Entry>>)
        case getEntries
        case filterEntries
    }
    
    
    var body: some ReducerOf<Self> {
        @Dependency (\.journalListDataManager.load) var loadEntries
        Reduce { state, action in
            switch action {
            case .addEntry:
                debugPrint("Adding items")
                return .none
            case .cancelEntry:
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
                      observe: { $0 }) { viewStore in
            NavigationStack {
                if viewStore.state.journalEntries.isEmpty {
                    EmptyJournalView()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: columns,
                            spacing: 16) {
                                ForEach(viewStore.state.journalEntries) { entry in
                                    JournalEntryView.init(entry: entry)
                                }
                            }
                            .padding(.all, 46)
                    }
                }
            }
            .navigationTitle("Bread journal")
            .loader(isLoading: viewStore.state.isLoading)
            .onError(error: viewStore.state.error)
            .applyToolbar(viewStore: viewStore)
            .task {
                viewStore.send(.getEntries)
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
                        $0.journalListDataManager = .previewError
                    }))
            
        }
    }
}
