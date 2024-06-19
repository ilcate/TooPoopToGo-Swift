

import SwiftUI
import SDWebImageSwiftUI

struct SliderNextToYou: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var mapViewModel: MapModel
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .padding(.vertical, -1)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if !homeModel.nextToYou.isEmpty {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(homeModel.nextToYou.reversed(), id: \.self) { bathroom in
                                InformationOfSelectionView(bathroom: bathroom, mapViewModel: mapViewModel)
                                    .padding(.vertical, 3)
                                    .frame(width: 350)
                                
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .scrollTargetLayout()
                    }
                    .contentMargins(0, for: .scrollContent)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .padding(.vertical, -1)
            } else {
                Text("No bathroom next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 114)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
            }
        }
        .task {
            homeModel.foundNextToYou(api: api)
        }
    }
}

struct StreakButtons: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager
    
    var body: some View {
        VStack(spacing:6){
            HStack{
                Text("Streak")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
            }
            if homeModel.status == "active" || homeModel.status == "on_cooldown" {
                ZStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("Poop Streak!")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 30, fontColor: .cLightBrown)
                            Spacer()
                        }
                        Spacer()
                    }.padding(.top, 12)
                    VStack{
                        Spacer()
                        HStack(alignment: .bottom){
                            VStack(alignment: .leading){
                                Text("Keep it going!")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                                
                                
                                if homeModel.status == "active"{
                                    ButtonPoop(text: "Drop a Poop")
                                        .onTapGesture {
                                            homeModel.updatePS(api: api)
                                            homeModel.scheduleNotificationForNextDay()
                                        }
                                } else if  homeModel.status == "on_cooldown" {
                                    ButtonPoop(text: "Done")
                                    
                                }
                                
                            }
                            
                            Spacer()
                        }
                        
                    }.padding(.bottom, 16)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Text("\(homeModel.count)")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 100, fontColor: .cLightBrown)
                        }
                        
                    }
                    .padding(.bottom, -12)
                    
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: 140)
                .background(
                    Image("StreakGoing")
                        .resizable()
                        .scaledToFill()
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else if homeModel.status == "expired"  {
                VStack{
                    HStack(alignment: .bottom){
                        Text("You lost a")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                        Text("\(homeModel.count)")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .cLightBrown)
                            .padding(.vertical, -5)
                        Text("days streak!")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                        Spacer()
                    }.padding(.bottom, 8)
                    
                    Spacer()
                    HStack(alignment: .bottom){
                        Text("You forgot to Poop?")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown)
                        Spacer()
                        ButtonPoop(text: "Restart")
                            .onTapGesture {
                                homeModel.updatePS(api: api)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical)
                .frame(maxWidth: .infinity, minHeight: 133)
                .background(
                    Image("StreakBreack")
                        .resizable()
                        .scaledToFill()
                    
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }else{
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 132)
            }
            
            
        }.padding(.horizontal, 20)
           
    }
}



struct ButtonPoop : View {
    var text: String
    
    var body: some View {
        
        HStack(spacing: 6){
            if text != "Done"{
                Image("DropAPoop")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 26, height: 26)
            }
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: text != "Done" ? .accent : .white)
                .frame(height: 26)
        }.padding(.leading, text != "Done" ? 7 : 12).padding(.trailing, text != "Done" ? 8.5 : 12).padding(.vertical, 5)
            .background(text != "Done" ? .white : .cPurpura)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
        
    }
}

struct NextBadge: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var tabBarSelection: TabBarSelection
    @State var badges: [BadgesInfo] = []
    
    var nextBadge: BadgesInfo? {
        badges.filter { !$0.is_completed }
              .sorted {
                  if $0.completion == $1.completion {
                      return $0.badge_name < $1.badge_name
                  }
                  return $0.completion > $1.completion
              }
              .first
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Next badge")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
            }
            if let badge = nextBadge {
                HStack {
                    VStack(alignment: .leading, spacing: -12) {
                        Text(badge.badge_name)
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                        Text("\(badge.completion)%")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 48, fontColor: .accent)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 6)
                    Spacer()
                    WebImage(url: URL(string: "\(api.url)\(badge.badge_photo!)"), options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                        .resizable()
                        .frame(width: 58, height: 58)
                        .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: 86)
                .background(Color.cLightBrown50)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Text("No upcoming badges")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .frame(maxWidth: .infinity, minHeight: 84)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .onTapGesture {
            self.tabBarSelection.selectedTab = 3
            self.tabBarSelection.selectedBadge = nextBadge!.badge_name
        }
        .padding(.horizontal, 20)
        .task {
            api.getBadges { resp in
                switch resp {
                case .success(let arr):
                    badges = arr
                case .failure(let error):
                    print("Failed to load badges: \(error)")
                }
            }
        }
    }
}

struct TipView: View {
    @EnvironmentObject var api: ApiManager
    @State var tips: [Tip] = []
    @State var currentTipID: String? = nil

    var body: some View {
        if tips.isEmpty {
            Color.white
                .frame(width: 350, height: 155)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(tips) { tip in
                        VStack {
                            HStack {
                                HStack(spacing: 2) {
                                    Image("Advice")
                                        .renderingMode(.original)
                                    Text("Daily Advice")
                                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 12, fontColor: .accent)
                                }
                                .padding(.leading, 7)
                                .padding(.trailing, 6)
                                .padding(.vertical, 1)
                                .background(.ultraThickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            
                            Spacer()
                            
                            VStack {
                                HStack {
                                    Text(tip.title)
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                                    Spacer()
                                }
                                .padding(.leading, 4)
                                HStack {
                                    Text(tip.description)
                                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 13, fontColor: .accent)
                                    Spacer()
                                }
                                .padding(.leading, 4)
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        .background(
                            CustomAsyncImage(
                                imageUrlString: tip.tip_photo,
                                placeholderImageName: "TipBG",
                                size: CGSize(width: 350, height: 145),
                                shape: .rectangle(cornerRadius: 16),
                                maxFrame: false
                            )
                            
                        )
                        .frame( width: 350, height: 145)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $currentTipID, anchor: .leading)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .ignoresSafeArea(.all, edges: .top)
        }
        
        HStack(spacing: 6) {
            ForEach(tips, id: \.self) { position in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(position.id == currentTipID ? .accent : .cLightBrown50)
            }
        }
        .padding(.bottom, -8)
        .padding(.top, 2)
        .onAppear {
            api.getTip { res in
                switch res {
                case .success(let suggest):
                    tips = suggest.results!
                    if let firstTip = tips.first {
                        currentTipID = firstTip.id
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
