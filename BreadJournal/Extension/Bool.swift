//
//  Bool.swift
//  BreadJournal
//
//  Created by Michel Goñi on 28/1/24.
//

import Foundation

extension Bool {
    
    var elementUsedTitle: String {
        switch self {
        case true:
            return "Sí"
        case false:
            return "No"
        }
    }
}
