import SwiftUI

struct LogInAndSignUp: View {
    @EnvironmentObject var onBoarding: OnBoarding
    @EnvironmentObject var api : ApiManager
    
    @Binding var path: [String]
    @FocusState private var isFocused: Bool
    @State var isLogIn: Bool
    @State var passwordVisibility = false
    @State private var username = ""
    @State private var firstName = ""
    @State private var email = ""
    @State private var password = ""
    
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
                TextFieldCustom(stateVariable: $username, name: "Username")
                if !isLogIn {
                    TextFieldCustom(stateVariable: $firstName, name: "First name")
                    TextFieldCustom(stateVariable: $email, name: "Email")
                }
                HStack {
                    if passwordVisibility {
                        TextField("Enter a password", text: $password)
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.trailing, -24)
                            .focused($isFocused)
                        
                    } else {
                        SecureField("Enter a password", text: $password)
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.trailing, -24)
                            .focused($isFocused)
                    }
                    Image(!passwordVisibility ? "visible" : "invisible")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.accent)
                        .onTapGesture {
                            passwordVisibility.toggle()
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
            
            Spacer()
            Text(!isLogIn ? "You are already registered? Log In" : "Don't have an account? Sign Up")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                .onTapGesture {
                    isLogIn.toggle()
                }
            FullRoundedButton(text: !isLogIn ? "Join now!" : "Log In")
                .onTapGesture {
                    if isLogIn {
                       
                        let info = LogInInformation(username: username, password: password)
                        api.getToken(userData: info) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let token):
                                    path.removeAll()
                                    onBoarding.onBoarding = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        api.saveToken(token: token)
                                    }
                            
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                    } else {
                        let parameters = RegisterRequest(username: username, email: email, first_name: firstName, password: password, last_login: nil)
                        
                        
                        api.createAccount(parameters: parameters){ result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    api.email = email
                                    api.username = username
                                    api.password = password
                                    path.append("InsertOtp")
                                case .failure(let error):
                                    print("sorry but no \(error)")
                                }
                            }
                            
                        }
                    }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .padding(.top, 8)
                .background(Color.cLightBrown)
        }
}
