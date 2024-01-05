//
//  Date.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import Foundation

public extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}

