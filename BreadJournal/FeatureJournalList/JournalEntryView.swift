//
//  JournalEntryView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//
import ComposableArchitecture
import Foundation
import SwiftUI

//@Reducer
//struct JournalDetailFeature {
//    @ObservableState
//    struct State: Equatable, Identifiable {
//        var entry: Entry
//        let id: UUID
//    }
//    
//    enum Action {
//        case favoriteTapped
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .favoriteTapped:
//                return .none
//            }
//        }
//    }
//}

struct JournalEntryView: View {
    
    @Bindable var store: StoreOf<JournalDetailViewFeature>
    public var body: some View {
        
        HStack {
            NavigationLink (destination: JournalDetailView(store: store)) {
                VStack {
                    Image("")
                        .optionalUIImage(store.journalEntry.breadPicture)
                        .clipShape(Capsule())
                }
                VStack {
                    HStack {
                        Text(store.journalEntry.name)
                            .font(.body)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
                            .padding(.bottom, 1.0)
                        store.journalEntry.isFavorite.favoriteImage
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .light))
                    }
                    Text(store.journalEntry.entryDate.convertToMonthYearFormat())
                        .font(.callout)
                        .fontWeight(.light)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                        .padding(.bottom, 16)
                    RatingView(rating: store.journalEntry.rating)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
}

#Preview ("Favorite true") {
    
    JournalEntryView(
        store: Store(
            initialState: JournalDetailViewFeature.State(
                journalEntry: Entry(
                    entryDate: Date(),
                    isFavorite: true,
                    rating: 3,
                    name: "Pan de centeno",
                    image: nil,
                    id: Entry.ID()), id: UUID()),
            reducer: {
                JournalDetailViewFeature()
            }))
    
}

#Preview("Favorite false") {
    
    JournalEntryView(
        store: Store(
            initialState: JournalDetailViewFeature.State(
                journalEntry: Entry(
                    entryDate: Date(),
                    isFavorite: false,
                    rating: 1,
                    name: "Pan de maíz",
                    image: nil,
                    id: Entry.ID()), id: UUID()),
            reducer: {
                JournalDetailViewFeature()
            }))
    
}
