//
//  MapSelectPosition.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct MapSelectPositionView: View {
    @ObservedObject var mapViewModel: MapModel
    
    var body: some View {
        
        ZStack{
            VStack{
                Image("marker")
                    .resizable()
                    .frame(width: 40, height: 49)
                    .padding(.bottom, 50)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(.black.opacity(0.2))
            .allowsHitTesting(false)
            
            VStack(spacing: 0){
                HStack{
                    Image("BackArrow")
                        .uiButtonStyle(backgroundColor: .cLightBrown)
                        .onTapGesture {
                            //mapViewModel.resetAndFollow(z: 18)
                            mapViewModel.canMoveCheck(duration: 0)
                        }
                    Spacer()
                    Text("Add a Toilet")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 24, fontColor: .accentColor)
                        .padding(.trailing, 44)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, maxHeight: 72)
                .background(.white)
                
                VStack(spacing: 0){
                    CustomDividerView()
                    Text("Move the map to precisely locate the bathroom")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 14, fontColor: .accentColor)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(.white)
                }
                Spacer()
                
            }
            
            VStack{
                Spacer()
                NavigationLink(destination: SheetAddAn(mapViewModel: mapViewModel)) {
                    FullRoundedButton(text: "Confirm position")
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        
                    //.onTapGesture {//mapViewModel.openAddSheet = true //mapViewModel.addAnnotation()}
                }
                
                .background(.white)
            }
            .ignoresSafeArea(.all)
        }
        .padding(.bottom, -4)
        
    }
}
