//
//  File.swift
//  BreadJournal
//
//  Created by Michel Goñi on 26/1/24.
//

import Foundation
import SwiftUI

struct IngredientsHeaderView: View {
    var addItem: (String) -> Void
    @State private var newIngredient = ""
    var body: some View {
        HStack {
            Text("Ingredientes")
                .font(.headline)
            Spacer()
            Button(action: {
                addItem(newIngredient)
                
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.green)
            }
        }
    }
}
