//
//  DispStarRating.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI


struct DispStarsRating: View {
    let starToDisplay : Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<starToDisplay, id: \.self) { _ in
                Image("StarFill")
                    .resizable()
                    .foregroundStyle(.accent)
                    .frame(width: 12, height: 12)
            }
            if starToDisplay < 5 {
                ForEach(0..<5 - starToDisplay, id: \.self) { _ in
                    Image("StarEmpty")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 12, height: 12)
                }
            }
        }
    }
}

