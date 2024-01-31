//
//  App.swift
//  BreadJournal
//
//  Created by Michel Goñi on 31/1/24.
//

import ComposableArchitecture
import SwiftUI


@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action{}
        }
    }
}

struct AppView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AppView()
}
