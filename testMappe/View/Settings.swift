

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var api : ApiManager
    @EnvironmentObject var onBoarding : OnBoarding
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
    
        VStack{
            ZStack{
                
                VStack{
                    
                    VStack(spacing: 10){
                        TextBoxSettings(text: "Change theme")
                        TextBoxSettings(text: "Change app icon")
                        TextBoxSettings(text: "Storage information")
                        TextBoxSettings(text: "Delete cache")
                        TextBoxSettings(text: "Contact us")
                    }.padding(.top, 8)
                        .padding(.horizontal, 20)
                    
                   
                    
                    Spacer()
                    FullRoundedButtonRed(text: "Log out")
                        .onTapGesture {
                            api.clearToken()
                            onBoarding.onBoarding = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                dismiss()
                            }
                        }
                }.padding(.top, 62)
                
                
                HeaderProfile(screenName: "Settings", name: "")
            }.navigationBarBackButtonHidden()
                .background(.cLightBrown)
            
            
            
        }
    }
}


struct TextBoxSettings:View {
    let text : String
    var body: some View {
       
            HStack{
                Text(text)
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
                Image("LightArrow")
                    .rotationEffect(.degrees(90))
                    .foregroundStyle(.accent)
            }.padding(.horizontal, 16)
            .padding(.vertical, 12)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        
       
    }
}
