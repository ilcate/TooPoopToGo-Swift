//
//  BadgeView.swift
//  testMappe
//
//  Created by Christian Catenacci on 26/04/24.
//

import SwiftUI

struct BadgeView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    let badges = [
        "Review Writer",
        "Feedback Guru",
        "Evaluation Expert",
        "Opinion Master",
        "Assessment Ace",
        "Critique Champion",
        "Insight Innovator",
        "Analysis Aficionado",
        "Judgment Jedi",
        "Feedback Fiend"
    ]
    
    var body: some View {
        VStack{
            HeadersViewPages(PageName: "Badges")
            Spacer()
            
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(badges, id: \.self) { badge in
                        NavigationLink(destination: BadgeDetail()) {
                            VStack{
                                Image("ImagePlaceHolder7")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 58, height: 58)
                                Text(badge)
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 12, fontColor: .accent)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .padding(8)
                            .frame(width: 80)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.bottom, 8)
                        }
                    }
                }.padding(.horizontal, 20)
                    .padding(.top, 8)
            }
        }.background(.cLightBrown)
    }
}
