//
//  SmallTag.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct SmallTag: View {
    var text : String
    
    var body: some View {
        HStack(spacing: 2){
            Image("\(text)Stroke")
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(.accent)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: Color.accent)
        }
        .padding(.vertical, 5.5).padding(.leading, 5).padding(.trailing, 7)
        .background(.cLightBrown)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
}
