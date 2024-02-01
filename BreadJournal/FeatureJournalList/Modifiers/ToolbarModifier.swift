//
//  ToolbarModifier.swift
//  BreadJournal
//
//  Created by Michel Goñi on 9/1/24.
//

import ComposableArchitecture
import SwiftUI

struct ToolbarModifier: ViewModifier {
    let store: StoreOf<BreadJournalListFeature>

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        store.send(.addEntryTapped)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 40, weight: .light))
                    }
                    .padding(.top, 48)

                    Spacer()

                    Button {
                        store.send(.filterEntries)
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 40, weight: .light))
                    }
                    .padding(.top, 48)
                }
            }
    }
}

extension View {
    func applyToolbar(store: StoreOf<BreadJournalListFeature>) -> some View {
        self.modifier(ToolbarModifier(store: store))
    }
}

