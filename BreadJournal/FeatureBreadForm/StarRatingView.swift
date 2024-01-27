//
//  StarRatingView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 26/1/24.
//

import Foundation
import SwiftUI


struct StarRatingView: View {
    @Binding var rating: Int
    let maximumRating: Int = 5
    
    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}
