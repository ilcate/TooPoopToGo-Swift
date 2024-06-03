

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var api : ApiManager
    @EnvironmentObject var onBoarding : OnBoarding
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
    
        VStack{
            ZStack{
                
                VStack{
                    HStack{
                        Text("User informations:")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                        Spacer()
                    }.padding(.horizontal, 20)
                   
                    
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
            
            
            
        }
    }
}

