//
//  ToolbarModifier.swift
//  BreadJournal
//
//  Created by Michel Goñi on 9/1/24.
//

import ComposableArchitecture
import SwiftUI

struct ToolbarModifier: ViewModifier {
    let viewStore: ViewStore<BreadJournalLisFeature.State, BreadJournalLisFeature.Action>

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        viewStore.send(.addEntryTapped)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 40, weight: .light))
                    }
                    .padding(.top, 48)

                    Spacer()

                    Button {
                        viewStore.send(.filterEntries)
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
    func applyToolbar(viewStore: ViewStore<BreadJournalLisFeature.State,
                      BreadJournalLisFeature.Action>) -> some View {
        self.modifier(ToolbarModifier(viewStore: viewStore))
    }
}

