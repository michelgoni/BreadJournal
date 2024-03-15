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
    
    func toHourMinuteString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
    
    static var yearMonthDay: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components) ?? Date()
    }
    
    static var mockRandomyearMonthDay: Date {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "es_ES")
        calendar.timeZone = TimeZone(identifier: "Europe/Madrid") ?? calendar.timeZone
        
        let date = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = .random(in: 1..<25)
        return calendar.date(from: components) ?? Date()
    }
}

