//
//  BreadErrorModifier.swift
//  BreadJournal
//
//  Created by Michel Goñi on 16/1/24.
//

import Foundation
import SwiftUI

struct BreadErrorModifier: ViewModifier {
    
    let error: Error?
    
    func body(content: Content) -> some View {
        ZStack {
            if let error = error {
                VStack(spacing: 16) {
                    Text("An Error Occured")
                        .font(Font.system(size: UIFont.preferredFont(forTextStyle: .title1).pointSize))
                    
                    Text(error.localizedDescription)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            else {
                content
            }
        }
    }
}

extension View {
    func onError(error: Error?) -> some View {
        modifier(BreadErrorModifier(error: error))
    }
}
