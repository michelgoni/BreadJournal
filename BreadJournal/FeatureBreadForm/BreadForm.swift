//
//  BreadForm.swift
//  BreadJournal
//
//  Created by Michel Goñi on 21/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BreadFormFeature {
    struct State: Equatable {
        @BindingState var journalEntry: Entry
        
        init(journalEntry: Entry) {
            self.journalEntry = journalEntry
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
            
        }
    }
}

struct BreadFormView: View {
    let store: StoreOf<BreadFormFeature>
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            Text(verbatim: viewStore.journalEntry.name)
        }
       
    }
}

#Preview {
    MainActor.assumeIsolated {
        NavigationStack {
            BreadFormView(
                store: Store(
                    initialState: BreadFormFeature.State(
                        journalEntry: .mock
                    ),
                    reducer: {
                        BreadFormFeature()
                    })
            )
        }
    }
}
