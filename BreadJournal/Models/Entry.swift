//
//  Entry.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import UIKit

public enum Filter {
    case date
    case rank
    case sourdough
    case yeast
}

public struct Entry: Codable, Identifiable, Equatable {

    let date: Date
    let isFavorite: Bool
    let rating: Int
    let name: String
    let image: Data?
    public let id: UUID
    
    static let all = [Entry(date: Date(), isFavorite: false, rating: 2, name: "Pan de centeno", image: nil, id: UUID()),
                      Entry(date: Date(), isFavorite: true, rating: 2, name: "Pan de escanda", image: nil, id: UUID()),
                      Entry(date: Date(), isFavorite: false, rating: 5, name: "Pan de trigo", image: nil, id: UUID()),
                      Entry(date: Date(), isFavorite: true, rating: 3, name: "Pan de maíz", image: nil, id: UUID())
    ]
}

extension Entry {
    public var breadPicture: UIImage? {
        guard let image else { return nil }
        return UIImage(data: image)
    }
}


    

