import SwiftUI
import Alamofire

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api : ApiManager
    @StateObject var profileModel = ProfileModel()
    
    var body: some View {
            ZStack{
                VStack{
                    VStack{
                        Spacer()
                        HStack(alignment: .bottom){
                            Image("ImagePlaceHolder3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .padding(.leading, 20)
                            VStack(alignment: .leading){
                                Text(profileModel.userInfo.username.capitalized)
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .accent)
                                Text("\(profileModel.userInfo.friends_number) Friends - \(profileModel.userInfo.badges.count) Badges")
                                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                            }
                            .padding(.leading, 12)
                            Spacer()
                        }
                        
        
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .background(.white)
                    .ignoresSafeArea()
               
                    VStack(spacing: 12){
                        VStack(spacing: 8){
                            HStack{
                                Text("Badges")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                                Spacer()
                            }
                            Text("You dont have any badge")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                                .frame(maxWidth: .infinity, maxHeight: 80)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        VStack(spacing: 8){
                            HStack{
                                Text("Recents Reviews")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                                Spacer()
                            }
                            Text("Go to review your first bathroom")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(spacing: 8){
                            HStack{
                                Text("Recents Notifications")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                                Spacer()
                            }
                            Text("Cmon try to do something")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                        }
                        
                         
                    }.padding(.top, -48).padding(.horizontal, 20)
                    Spacer()
                    
                }
                
                VStack{
                    HStack{
                        Image("BackArrow")
                            .uiButtonStyle(backgroundColor: .cLightBrown)
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Spacer()
                        Text("Profile")
                            .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image("Share")
                                .uiButtonStyle(backgroundColor: .cLightBrown)
                        }
                        
                    }
                    .padding(.top, 8)
                    .task{
                        profileModel.getProfile(api: api)
                    }
                    Spacer()
                } .padding(.horizontal, 20)
                    .navigationBarBackButtonHidden(true)
                    
                
                
                
            }
            .background(.cLightBrown)
       
    }
}
