//
//  File.swift
//  BreadJournal
//
//  Created by Michel Goñi on 26/1/24.
//


import ComposableArchitecture
import SwiftUI

struct IngredientsHeaderView: View {
    var viewStore: Store<BreadFormFeature.State, BreadFormFeature.Action>
    var body: some View {
        HStack {
            Text("Ingredientes")
                .font(.headline)
            Spacer()
            Button(action: {
                viewStore.send(.addIngredientTapped)
                
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.green)
            }
        }
    }
}

#Preview {
    IngredientsHeaderView(
        viewStore: Store(initialState: BreadFormFeature.State(journalEntry: .mock), reducer: {
            BreadFormFeature()
        })
    )
}
