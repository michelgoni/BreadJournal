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
    
    var autolysisTime = ""
    var entryDate = Date.yearMonthDay
    var isFavorite = false
    var rating = Int.zero
    var name = ""
    var image: Data?
    let id: UUID
    var ingredients: IdentifiedArrayOf<Ingredient> = []
    var kneadingProcess = ""
    var sourdoughFeedTime = ""
    var sourdoughFeedTemperature = ""
    var autolysisStartingTime = Date.yearMonthDay
    var bulkFermentationStartingTime = ""
    var secondFermentarionTime = ""
    var fridgeTotalTime = ""
    var folds = ""
    var breadFormingTime = Date.yearMonthDay
    var isFridgeUsed = true
    var bakingProcedureAndTime = ""
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
    
    static let mockTest = Entry(
        entryDate: Date.yearMonthDay,
        name: "Pan de centeno",
        id: UUID(0)
    )
    
    static let mock = Entry(
        autolysisTime: "Sin autólisis",
        isFavorite: false,
        rating: 2,
        name: "Pan de centeno",
        image: nil,
        id: UUID(0),
        ingredients: [Ingredient(id: Ingredient.ID(UUID(0)), ingredient: "100 grs de Harina"),
                      Ingredient(id: Ingredient.ID(UUID(1)), ingredient: "300 grs de Agua"),
                      Ingredient(id: Ingredient.ID(UUID(2)), ingredient: "10 grs de sal"),
                      Ingredient(id: Ingredient.ID(UUID(3)), ingredient: "100 grs de Harina de centeno")], 
        kneadingProcess: "Amasado Fisterra",
        sourdoughFeedTime: "3 horas",
        sourdoughFeedTemperature: "24º",
        bulkFermentationStartingTime: "3 horas",
        secondFermentarionTime: "2 horas",
        fridgeTotalTime: "12 horas",
        folds: "4",
        bakingProcedureAndTime: "15 minutos con calor solo debajo al máximo y 40 minutos a 220º con calor arriba y abajo. Con vapor.",
        isSteelPlateUsed: true,
        crumbRating: 3,
        bloomRating: 3, 
        scoreRating: 4,
        tasteRating: 4,
        evaluation: 4)
    
    static let mock2 = Entry(
        isFavorite: true,
        rating: 4,
        name: "Pan de maíz",
        image: nil,
        id: UUID(1),
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
            self.image = newValue?.jpegData(compressionQuality: 1.0)
        }
    }
}


    

