//
//  FavoriteButtonView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 6/3/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer

struct Favoriting {
    @ObservableState
    struct State: Equatable {
        var isFavorite: Bool
    }
    enum Action {
        case buttonFavoriteTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buttonFavoriteTapped:
                state.isFavorite.toggle()
                return .none
            }
        }
    }
}

struct FavoriteButton: View {
    @Bindable var store: StoreOf<Favoriting>
    var body: some View {
        Button {
            store.send(.buttonFavoriteTapped)
        } label: {
            Image(systemName: "heart")
                .symbolVariant(
                    store.isFavorite ? .fill : .none)
        }
        .foregroundColor(.black)
        .font(.system(size: 20, weight: .light))
    }
}

#Preview ("Favorite true") {
    
    FavoriteButton(store: Store(
        initialState: Favoriting.State(
            isFavorite: true),
        reducer: {
        Favoriting()
    }))
}


#Preview ("Favorite false") {
    
    FavoriteButton(store: Store(
        initialState: Favoriting.State(
            isFavorite: false),
        reducer: {
        Favoriting()
    }))
}

