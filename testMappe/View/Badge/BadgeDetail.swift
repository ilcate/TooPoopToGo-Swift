//
//  BadgeDetail.swift
//  testMappe
//
//  Created by Christian Catenacci on 16/05/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct BadgeDetail: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    @Binding var id : String
    @Binding var com : Int
    @Binding var completed : Bool
    @Binding var completedDate : String
    @State var badgeSel = BadgesInfoDetailed(name: "", description: "", badge_requirement_threshold: 0, badge_photo: "")
    @State var isAnimating = false
    
    var body: some View {
        ZStack{
            if completed {
                Image("Lights")
                    .resizable()
                    .renderingMode(.original)
                    .frame(maxWidth: 800, maxHeight: 800)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        self.isAnimating = true
                    }
                    .padding(.top, -130)
            }
            
            VStack{
                UpperSheet(text: "Badge information", pBottom: 14, pHor: 0)
                    .padding(.top, 16)
                WebImage(url: URL(string: "\(badgeSel.badge_photo.replacingOccurrences(of: "http://", with: "https://"))"), options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                    .resizable()
                    .frame(width: 150, height: 150)
                    .applyGrayscale(completed ? 0 : 1)
                
                HStack{
                    Text(badgeSel.name)
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                    Spacer()
                }.padding(.top, 12)
                
                
                
                HStack{
                    Text(badgeSel.description)
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                    Spacer()
                }
                
                Spacer()
                
                
                if !completed {
                    ZStack{
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(.cMidBrown)
                                .frame(maxWidth: geometry.size.width, maxHeight: 26 )
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                            Rectangle()
                                .fill(.accent)
                                .frame(maxWidth: geometry.size.width * (Double(com > 8 ? com : 8) / 100.0 ), maxHeight: 26 )
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                        }.frame(height: 26)
                        
                        HStack{
                            Text("Progression")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                            Spacer()
                            Text("\(badgeSel.name == "Review writer" ? Int(com / 10) : Int(com) )/\(Int(badgeSel.badge_requirement_threshold))")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                        }
                        .padding(.horizontal, 16)
                    }
                } else {
                    ZStack{
                        Rectangle()
                            .fill(.accent)
                            .frame(maxWidth: .infinity, maxHeight: 26 )
                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                        HStack{
                            Text("Completed")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                            Spacer()
                            Text(completedDate)
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                        }
                        .padding(.horizontal, 16)
                    }
                }
               
                
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
            .task {
                api.getSpecificBadge(badgeId: id) { resp in
                    switch resp {
                    case .success(let arr):
                        badgeSel = arr
                    case .failure(let error):
                        print("Failed to load badges: \(error)")
                    }
                }
            }
            
        }
        
    }
}
