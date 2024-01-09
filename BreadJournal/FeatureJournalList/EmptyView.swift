//
//  EmptyView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 9/1/24.
//

import SwiftUI

private extension String {
    static let pencil = "pencil"
    static let title = "There are no entries your diary yet"
}


struct EmptyJournalView: View {
    var body: some View {
        VStack {
            Image(systemName: .pencil)
                .imageScale(.large)
            Text(verbatim: .title)
                .font(.headline)
                .padding()
            Image(systemName: .pencil)
                .imageScale(.large)
        }
    }
}

#Preview {
    EmptyJournalView()
}

