//
//  ReviewsScroller.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct ReviewsScroller: View {
    let reviews: [Review]?
    let isProfile : Bool
    let isShort : Bool
    @EnvironmentObject var mapViewModel: MapModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                if !reviews!.isEmpty {
                    if let reviews = reviews {
                        ForEach(reviews, id: \.self) { review in
                            if !review.review.isEmpty{
                                ReviewTemp(review: review, isProfile: isProfile, isShort: isShort, mapViewModel: mapViewModel)
                            }
                        }
                        if reviews.count == 1 && reviews[0].review == "" {
                            NoReviews(isProfile : isProfile)
                        }
                    }
                } else {
                    NoReviews( isProfile : isProfile)
                }
            }
            .padding(.trailing, -10)
            .scrollTargetLayout()
        }
        .contentMargins(20, for: .scrollContent)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .padding(.vertical, -20)
    }
}
