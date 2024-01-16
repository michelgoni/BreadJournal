//
//  LoaderModifier.swift
//  BreadJournal
//
//  Created by Michel Goñi on 16/1/24.
//

import Foundation
import SwiftUI

private extension CGFloat {
    static let loadingRadiusBlur = 10.0
}

private extension Double {
    static let loadedOpacity = 1.0
}

struct LoaderModifier: ViewModifier {

    var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? .loadingRadiusBlur : .zero)

            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(maxWidth: .infinity, 
                       maxHeight: .infinity)
                .foregroundColor(.primary)
                .opacity(isLoading ? .loadedOpacity : .zero)
            }
        }
    }
}

extension View {
    func loader(isLoading: Bool) -> some View {
        modifier(
            LoaderModifier(
                isLoading: isLoading)
        )
    }
}
