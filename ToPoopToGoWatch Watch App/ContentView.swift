//
//  ContentView.swift
//  ToPoopToGoWatch Watch App
//
//  Created by Christian Catenacci on 31/05/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var homeModel = HomeModelWatch()
    @StateObject var api = ApiManagerWatch()
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                Spacer()
            }
            ScrollView{
                VStack{
                    ForEach(homeModel.nextToYou){ element in
                        VStack{
                            HStack{
                                Text(element.name!)
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .white)
                                    .padding(.horizontal, 12)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            
                        }
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background(.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                       
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .onAppear{
            homeModel.foundNextToYou(api: api)
        }
    }
}

#Preview {
    ContentView()
}
