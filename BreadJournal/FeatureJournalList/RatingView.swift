//
//  RatingView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct RatingFeature {
    @ObservableState
    struct State: Equatable {
        var rating: Int = .zero
    }
    enum Action {
        case ratingTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .ratingTapped:
                
                return .none
            }
        }
        
    }
}


struct RatingView: View {

    @State var rating: Int
//    @Bindable var store: StoreOf<RatingFeature>

    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }

    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}
