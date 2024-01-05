//
//  File.swift
//  
//
//  Created by Michel Goñi on 18/8/23.
//

import Foundation
import SwiftUI

private extension String {
    static let heartFill = "heart.fill"
    static let heart = "heart"
}

extension Bool {
    @available(iOS 13.0, *)
    var favoriteImage: Image {
        switch self {
        case true:
            return Image(systemName: .heartFill)
        case false:
            return Image(systemName: .heart)
        }
    }
}
