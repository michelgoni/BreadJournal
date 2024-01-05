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
    }
    
    enum Action {
        case addEntry
        case filterEntries
        case cancelEntry
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addEntry:
                return .none
            case .cancelEntry:
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
        WithViewStore(self.store, observe: \.journalEntries) { viewStore in
            NavigationStack {
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
                .navigationTitle("Bread journal")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.black)
                                .font(
                                    .system(
                                        size: 40,
                                        weight: .light)
                                )
                        }
                        .padding(.top, 48)
                        Spacer()
                        Button {
                            print("Filter tapped!")
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .foregroundColor(.black)
                                .font(
                                    .system(
                                        size: 40,
                                        weight: .light)
                                )
                        }
                        .padding(.top, 48)
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
                    initialState: BreadJournalLisFeature.State(
                        journalEntries: [.mock]),
                    reducer: {
                        BreadJournalLisFeature()
                    }))
        }
    }
}
