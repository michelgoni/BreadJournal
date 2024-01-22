//
//  BreadForm.swift
//  BreadJournal
//
//  Created by Michel Goñi on 21/1/24.
//

import ComposableArchitecture
import Foundation

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
