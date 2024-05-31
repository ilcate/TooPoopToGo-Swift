
import Foundation
import SwiftUI
import Alamofire

final class OnBoardingModel: ObservableObject{
    var PagesOnBoarding = ["Find", "Review", "More", "Pipo"]
    @Published var position: String?
    @Published var navigateToLogInAndSignUp = false
    @Published var passwordVisibility = false
    @Published var username = ""
    @Published var firstName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var everithingOk = true
    @Published var otpOk = true
    @Published var otp = Array(repeating: "", count: 6)
    
    
    func nextButton(path: [String], completion: @escaping ([String]) -> Void) {
        var mutablePath = path
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                if let indexOfA = self.PagesOnBoarding.firstIndex(of: self.position!) {
                    let nextIndex = indexOfA + 1
                    if nextIndex < self.PagesOnBoarding.count {
                        self.position = self.PagesOnBoarding[nextIndex]
                    } else {
                        mutablePath.append("ChoseLogM")
                        self.navigateToLogInAndSignUp = true
                    }
                }
                completion(mutablePath)
            }
        }
    }
    
    func doLogIn(path: [String], api: ApiManager, onBoarding: OnBoarding , completion: @escaping ([String]) -> Void){
        let info = LogInInformation(username: username, password: password)
        var mutablePath = path
        api.getToken(userData: info) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    mutablePath.removeAll()
                    self.resetValues()
                    completion(mutablePath)
                    onBoarding.onBoarding = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        api.saveToken(token: token)
                    }
                case .failure:
                    self.everithingOk = false
                    self.resetValues()
                }
            }
        }
    }
    
    func doRegister(path: [String],  api: ApiManager, completion: @escaping ([String]) -> Void){
        let parameters = RegisterRequest(username: username, email: email, first_name: firstName, password: password, last_login: nil)
        var mutablePath = path
        api.createAccount(parameters: parameters){ result in
            print(result)
            DispatchQueue.main.async {
                switch result {
                case .success:
                    api.email = self.email
                    api.username =  self.username
                    api.password =  self.password
//                    api.id = self.
                    mutablePath.append("InsertOtp")
                    completion(mutablePath)
                case .failure:
                    self.everithingOk = false
                    self.resetValues()
                }
            }
            
        }
    }
    
    func insertOTP(path: [String],  api: ApiManager, onBoarding: OnBoarding, completion: @escaping ([String]) -> Void){
        let otpString = otp.joined()
        let otpToSend = SendOtp(otp: otpString, email: api.email)
        var mutablePath = path

        api.activateAccount(parameters: otpToSend) { res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    onBoarding.onBoarding = true
                    mutablePath.removeAll()
                    self.resetValues()
                    completion(mutablePath)
                    let loginInfo = LogInInformation(username: api.username, password: api.password)
                    api.getToken(userData: loginInfo) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let token):
                                api.saveToken(token: token)
//                                let renderer = ImageRenderer(content: ProfilePictureCustom()).uiImage
//                                api.uploadProfilePicture(image: renderer!, userId: api.i)
                            case .failure(_):
                                mutablePath.append("LogIn")
                                completion(mutablePath)
                                onBoarding.onBoarding = false
                            }
                        }
                    }
                case .failure:
                    self.otpOk = false 
                }
            }
        }
    }
    func handleTextChange(at index: Int, newValue: String, focusedField: inout Int?) {
            if newValue.count > 1 {
                otp[index] = String(newValue.last!)
            } else if !newValue.isEmpty {
                otp[index] = newValue
            }
            
            if !newValue.isEmpty {
                if index < 5 {
                    focusedField = index + 1
                } else {
                    focusedField = nil
                }
            }
        }
    func sanitizeOTP() {
        for i in 0..<6 where otp[i].count > 1 {
           otp[i] = String(otp[i].last!)
        }
    }
    
    func resetValues(){
        self.username = ""
        self.firstName = ""
        self.email = ""
        self.password = ""
    }

}
