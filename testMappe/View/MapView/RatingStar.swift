//
//  RatingStar.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct RatingsStars: View {
    var RatingName: String
    @State var RatingStars: [Stars]
    
    var body: some View {
        HStack{
            Text(RatingName)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
            Spacer()
            HStack(spacing: 4){
                ForEach(RatingStars.indices, id: \.self) { index in
                    Image(RatingStars[index].selected ? "StarFill" : "StarEmpty")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            RatingStars.indices.forEach { idx in
                                RatingStars[idx].selected = idx <= index ? true : false
                            }
                        }
                }
            }

        }
    }
}

