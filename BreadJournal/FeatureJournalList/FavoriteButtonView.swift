//
//  FavoriteButtonView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 6/3/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct FavoriteButton: View {
    @Bindable var store: StoreOf<JournalDetailViewFeature>
    var body: some View {
        Button {
            store.send(.favoriteTapped)
        } label: {
            Image(systemName: "heart")
                .symbolVariant(store.journalEntry.isFavorite ? .fill : .none)
        }
    }
}

#Preview ("Favorite true") {
    
    FavoriteButton(store: Store(
        initialState: JournalDetailViewFeature.State(
            journalEntry: Entry(
                isFavorite: true,
                id: UUID()),
            id: UUID()),
        reducer: {
            JournalDetailViewFeature()
        }))
}


#Preview ("Favorite false") {
    
    FavoriteButton(store: Store(
        initialState: JournalDetailViewFeature.State(
            journalEntry: Entry(
                isFavorite: false,
                id: UUID()),
            id: UUID()),
        reducer: {
            JournalDetailViewFeature()
        }))
}

