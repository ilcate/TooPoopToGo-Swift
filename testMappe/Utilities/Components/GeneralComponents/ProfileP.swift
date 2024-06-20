//
//  ProfileP.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct ProfileP: View {
    let link: String
    let size: CGFloat
    let padding: CGFloat
    
    var body: some View {
        VStack {
            
            CustomAsyncImage(
                imageUrlString: link,
                placeholderImageName: "noPhoto",
                size: CGSize(width: size, height: size),
                shape: .circle,
                maxFrame: false
            )
            

        }
        .padding(.leading, padding)
    }
        
}
