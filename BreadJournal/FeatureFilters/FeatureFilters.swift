//
//  FeatureFilters.swift
//  BreadJournal
//
//  Created by Michel Goñi on 17/3/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FiltersState {
    enum Filter {
        case filterByFavorites
        case filterByrating
        case filterBydate
    }
    
    @ObservableState
    struct State: Equatable {
        var filterState: Filter = .filterBydate
    }
    
    enum Action {
        case filterByFavorites
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .filterByFavorites:
                return .none
            }
        }
    }
}
