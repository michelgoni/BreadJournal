//
//  StarRatingView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 26/1/24.
//

import Foundation
import SwiftUI


struct StarRatingView: View {
    private var rating: Binding<Int>?
    private var staticRating: Int?
    private var isInteractive: Bool
    let maximumRating: Int

    init(rating: Binding<Int>, maximumRating: Int = 5) {
        self.rating = rating
        self.maximumRating = maximumRating
        self.isInteractive = true
    }

    init(staticRating: Int, maximumRating: Int = 5) {
        self.staticRating = staticRating
        self.maximumRating = maximumRating
        self.isInteractive = false
    }

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                Image(systemName: self.currentRating >= index ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        if isInteractive {
                            self.rating?.wrappedValue = index
                        }
                    }
            }
        }
    }

    private var currentRating: Int {
        if let staticRating = staticRating {
            return staticRating
        } else {
            return rating?.wrappedValue ?? 0
        }
    }
}
