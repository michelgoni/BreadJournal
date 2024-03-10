//
//  OptionalImageModifier.swift
//  
//
//  Created by Michel Goñi on 7/11/23.
//

import SwiftUI

struct OptionalImageModifier: ViewModifier {
    let uiImage: UIImage?

    func body(content: Content) -> some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 80, minHeight: 80)
            } else {
                Image(systemName: "photo")
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
    }
}

extension View {
    func optionalUIImage(_ uiImage: UIImage?) -> some View {
        self.modifier(OptionalImageModifier(uiImage: uiImage))
    }
}
