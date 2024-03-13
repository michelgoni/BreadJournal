//
//  EmptyView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 9/1/24.
//

import SwiftUI

private extension String {
    static let pencil = "pencil"
    static let title = "No hay entradas en tu diario"
}


struct EmptyJournalView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
               
                Text(verbatim: .title)
                    .font(.headline)
                    .padding()
             
                Spacer()
            }
            Spacer()
           
        }
    }
}

#Preview {
    EmptyJournalView()
}


struct IfEmptyModifier: ViewModifier {
    var itemCount: Int
    var alertPopulated: Bool
    
    func body(content: Content) -> some View {
        if itemCount == .zero && !alertPopulated {
            EmptyJournalView()
        } else {
            content
        }
    }
}

extension View {
    func emptyPlaceholder(if itemCount: Int, alertPopulated: Bool) -> some View {
        modifier(IfEmptyModifier(itemCount: itemCount, alertPopulated: alertPopulated))
    }
}
