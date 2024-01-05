//
//  Entry.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import UIKit

 enum Filter {
    case date
    case rank
    case sourdough
    case yeast
}

 struct Entry: Codable, Identifiable, Equatable {

    let date: Date
    let isFavorite: Bool
    let rating: Int
    let name: String
    let image: Data?
    let id: UUID
}

extension Entry {
    static let mock = Entry(date: Date(), 
                            isFavorite: false,
                            rating: 2, 
                            name: "Pan de centeno",
                            image: nil,
                            id: Entry.ID())
    
    static let mock2 = Entry(date: Date(),
                            isFavorite: true,
                            rating: 4,
                            name: "Pan de maíz",
                            image: nil,
                            id: Entry.ID())
    
}

extension Entry {
    public var breadPicture: UIImage? {
        guard let image else { return nil }
        return UIImage(data: image)
    }
}


    

