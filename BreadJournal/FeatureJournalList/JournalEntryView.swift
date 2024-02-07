//
//  JournalEntryView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import Foundation
import SwiftUI

struct JournalEntryView: View {
    let entry: Entry
    public var body: some View {

        HStack {
            VStack {
                Image("")
                    .optionalUIImage(entry.breadPicture)
                    .clipShape(Capsule())
            }
            VStack {
                HStack {
                    Text(entry.name)
                        .font(.body)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                        .padding(.bottom, 1.0)
                    entry.isFavorite.favoriteImage
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .light))
                }
                Text(entry.entryDate.convertToMonthYearFormat())
                    .font(.callout)
                    .fontWeight(.light)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    .padding(.bottom, 16)
                RatingView(rating: entry.rating)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .shadow(radius: 5)
      
    }
}

#Preview {
    
    JournalEntryView(entry: Entry(entryDate: Date(),
                                  isFavorite: true,
                                  rating: 3,
                                  name: "Pan de centeno",
                                  image: nil,
                                  id: Entry.ID()))
    
}

#Preview("Favorite false") {
    
    JournalEntryView(entry: Entry(entryDate: Date(),
                                  isFavorite: false,
                                  rating: 1,
                                  name: "Pan de maíz",
                                  image: nil,
                                  id: Entry.ID()))
    
}

