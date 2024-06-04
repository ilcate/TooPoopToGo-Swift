import SwiftUI

struct LogInAndSignUp: View {
    @EnvironmentObject var onBoarding: OnBoarding
    @Binding var path: [String]
    @EnvironmentObject var api: ApiManager
    @FocusState private var isFocused: Bool
    @State var isLogIn: Bool
    @ObservedObject var oBModel: OnBoardingModel

    var body: some View {
        VStack {
            HStack {
                Text(!isLogIn ? "Create Account" : "Log In")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 6)

            VStack {
                TextFieldCustom(stateVariable: $oBModel.username, name: "Username")
                if !isLogIn {
                    TextFieldCustom(stateVariable: $oBModel.firstName, name: "First name")
                    TextFieldCustom(stateVariable: $oBModel.email, name: "Email")
                        .background(oBModel.emailIsValid ? Color.white : Color.red.opacity(0.3))
                }
                HStack{
                    Text("Password")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                        .padding(.bottom, -3)
                    Spacer()
                }
                HStack {
                    if oBModel.passwordVisibility {
                        TextField("Enter a password", text: $oBModel.password)
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.trailing, -24).padding(.top, 8).padding(.bottom, 8)
                            .focused($isFocused)
                    } else {
                        SecureField("Enter a password", text: $oBModel.password)
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.trailing, -24).padding(.top, 8).padding(.bottom, 8)
                            .focused($isFocused)
                    }
                    Image(!oBModel.passwordVisibility ? "visible" : "invisible")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.accent)
                        .onTapGesture {
                            oBModel.passwordVisibility.toggle()
                            DispatchQueue.main.async {
                                isFocused = true
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: 30)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.accent, lineWidth: isFocused ? 3 : 0)
                )
            }
            .padding(.horizontal, 20)
            if !oBModel.everithingOklog {
                Text("Something went wrong, try again")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .red)
                Spacer()
            }
            if !oBModel.everithingOkreg {
                Text("This name is already used")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .red)
                Spacer()
            } else {
                Spacer()
            }
            
            Text(!isLogIn ? "You are already registered? Log In" : "Don't have an account? Sign Up")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                .onTapGesture {
                    isLogIn.toggle()
                }
            FullRoundedButton(text: !isLogIn ? "Join now!" : "Log In")
                .onTapGesture {
                    if isLogIn {
                        oBModel.doLogIn(path: path, api: api, onBoarding: onBoarding) { updatedPath in
                            path = updatedPath
                        }
                    } else {
                        oBModel.doRegister(path: path, api: api) { updatedPath in
                            path = updatedPath
                        }
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(Color.cLightBrown)
    }
}
