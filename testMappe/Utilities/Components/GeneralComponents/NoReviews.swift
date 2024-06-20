//
//  NoReviews.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct NoReviews: View {
    let isProfile : Bool
    var body: some View {
        VStack {
            Text(!isProfile ? "Try to add some friends, \n here you will find them reviews" : "This user doesn't have any review")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accent)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 144)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
        .padding(.trailing, 10)
        .padding(.bottom, -6)
        
    }
}
