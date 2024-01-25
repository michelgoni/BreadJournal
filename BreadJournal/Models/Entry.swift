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
    
    var date = Date()
    var isFavorite = false
    var rating = Int.zero
    var name = ""
    var image: Data?
    let id: UUID
    var lastSourdoughFeedTime = Date()
    var prefermentStartingTime = Date()
    var autolysisStartingTime = Date()
    var bulkFermentationStartingTime = Date()
    var secondFermentarionStartingTime = Date()
    var fridgeTotalTime = ""
    var folds = ""
    var breadFormingTime = Date()
    var isFridgeUsed = true
    var bakingTime = ""
    var isSteelPlateUsed = false
    var crustRating = Int.zero
    var crumbRating = Int.zero
    var bloomRating = Int.zero
    var scoreRating = Int.zero
    var tasteRating = Int.zero
    var evaluation = Int.zero
}

extension Entry {
    
    static let mock = Entry(
                            isFavorite: false,
                            rating: 2, 
                            name: "Pan de centeno",
                            image: nil,
                            id: Entry.ID())
    
    static let mock2 = Entry(
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


    

