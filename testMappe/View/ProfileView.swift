import SwiftUI
import Alamofire

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    @StateObject var profileModel = ProfileModel()
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        ZStack {
                            ProfileP(link: profileModel.userInfo.photo_user!, size: 70, padding: 20)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image("Edit")
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 26, height: 26)
                                }
                            }
                        }
                        .frame(width: 70, height: 70)
                        .padding(.leading, 10)
                        .onTapGesture {
                            profileModel.openSheetUploadImage = true
                        }
                        VStack(alignment: .leading) {
                            Text(profileModel.userInfo.username.capitalized)
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 32, fontColor: .accent)
                            Text("\(profileModel.userInfo.friends_number) Friends - \(profileModel.userInfo.badges.count) Badges")
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(Color.white)
                .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Badges")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                            Spacer()
                        }
                        Text("You don't have any badge")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    VStack(spacing: 8) {
                        HStack {
                            Text("Recents Reviews")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                            Spacer()
                        }
                        Text("Go to review your first bathroom")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    VStack(spacing: 8) {
                        HStack {
                            Text("Recents Notifications")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                            Spacer()
                        }
                        Text("C'mon, try to do something")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.top, -48)
                .padding(.horizontal, 20)
                Spacer()
            }
            
            VStack {
                HStack {
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
                .task {
                    profileModel.getProfile(api: api)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
        .background(Color.cLightBrown)
        .sheet(isPresented: $profileModel.openSheetUploadImage, onDismiss: {
            profileModel.openSheetUploadImage = false
            if !profileModel.imagesNewAnnotation.isEmpty {
                api.uploadProfilePicture(image: profileModel.imagesNewAnnotation[0], userId: profileModel.userInfo.id) { result in
                    switch result {
                    case .success(let resp):
                        profileModel.updateUserInfo(newUserInfo: resp)
                        profileModel.imagesNewAnnotation.removeAll()
                    case .failure(let error):
                        print("Failed to upload profile picture: \(error)")
                    }
                }
            }
        }) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                AddImageSheet(photosPickerItems: $profileModel.photosPikerItems, imagesNewAnnotation: $profileModel.imagesNewAnnotation, isMaxFivePhotos: false)
                    .presentationDetents([.fraction(0.26)])
                    .presentationCornerRadius(18)
            }
        }
    }
}
