//
//  Error.swift
//  BreadJournal
//
//  Created by Michel Goñi on 12/1/24.
//

import Foundation

enum BreadJournalError: Error {
    case general
    case underlying(Error)
    case databaseFailure(internalCode: Int)
}
