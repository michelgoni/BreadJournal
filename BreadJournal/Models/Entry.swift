//
//  Entry.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import UIKit
import Tagged
import ComposableArchitecture

 enum Filter {
    case date
    case rank
    case sourdough
    case yeast
}

struct Entry: Codable, Identifiable, Equatable {
    
    var entryDate = Date(timeIntervalSince1970: 0)
    var isFavorite = false
    var rating = Int.zero
    var name = ""
    var image: Data?
    let id: UUID
    var ingredients: IdentifiedArrayOf<Ingredient> = []
    var lastSourdoughFeedTime = Date(timeIntervalSince1970: 0)
    var prefermentStartingTime = Date(timeIntervalSince1970: 0)
    var autolysisStartingTime = Date(timeIntervalSince1970: 0)
    var bulkFermentationStartingTime = Date(timeIntervalSince1970: 0)
    var secondFermentarionStartingTime = Date(timeIntervalSince1970: 0)
    var fridgeTotalTime = ""
    var folds = ""
    var breadFormingTime = Date(timeIntervalSince1970: 0)
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

extension IdentifiedArray where ID == JournalDetailViewFeature.State.ID, Element == JournalDetailViewFeature.State {
    
    static let mocks: Self = [
        JournalDetailViewFeature.State(
            journalEntry: .mock,
            id: UUID()
        ),
        JournalDetailViewFeature.State(
            journalEntry: .mock2,
            id: UUID()
        )
    ]
}

extension Entry {
    
    static let mock = Entry(
        isFavorite: false,
        rating: 2,
        name: "Pan de centeno",
        image: nil,
        id: Entry.ID(),
        ingredients: [Ingredient(id: Ingredient.ID(UUID(0)), ingredient: "100 grs de Harina"),
                      Ingredient(id: Ingredient.ID(UUID(1)), ingredient: "300 grs de Agua"),
                      Ingredient(id: Ingredient.ID(UUID(2)), ingredient: "10 grs de sal"),
                      Ingredient(id: Ingredient.ID(UUID(3)), ingredient: "100 grs de Harina de centeno")])
    
    static let mock2 = Entry(
        isFavorite: true,
        rating: 4,
        name: "Pan de maíz",
        image: nil,
        id: Entry.ID(),
        ingredients: [
            Ingredient(id: Ingredient.ID(UUID(0)), ingredient: "100 grs de Harina"),
            Ingredient(id: Ingredient.ID(UUID(1)), ingredient: "300 grs de Agua"),
            Ingredient(id: Ingredient.ID(UUID(2)), ingredient: "10 grs de sal"),
            Ingredient(id: Ingredient.ID(UUID(3)), ingredient: "100 grs de Harina de centeno")
        ]
    )
    
}

struct Ingredient: Codable, Identifiable, Equatable {
    let id: Tagged<Self, UUID>
    var ingredient = ""
}

extension Entry {
    public var breadPicture: UIImage? {
        get {
            guard let imageData = self.image else { return nil }
            return UIImage(data: imageData)
        }
        set {
            self.image = newValue?.jpegData(compressionQuality: 1.0) // Or pngData()
        }
    }
}


    

