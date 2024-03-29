//
//  JournalEntryView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//
import ComposableArchitecture
import Foundation
import SwiftUI


struct JournalEntryView: View {
    
    @Bindable var store: StoreOf<JournalDetailViewFeature>
    public var body: some View {
        
        HStack {
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
                    FavoriteButton(
                        store: store.scope(
                        state: \.favoritingState, 
                        action: \.favoriteTapped))
                }
                Text(store.journalEntry.entryDate.convertToMonthYearFormat())
                    .font(.callout)
                    .fontWeight(.light)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    .padding(.bottom, 16)
                RatingView(store: store.scope(state: \.ratingState,
                                               action: \.ratingTapped))
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    id: UUID()), id: UUID()),
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
                    id: UUID()), id: UUID()),
            reducer: {
                JournalDetailViewFeature()
            }))
    
}
