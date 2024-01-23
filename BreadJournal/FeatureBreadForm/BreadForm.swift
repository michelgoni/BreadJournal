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
    
    struct Action: Equatable {}
    
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
        Text(verbatim: "Muy bien, no?")
    }
}
