import Foundation
import SwiftUI
import Alamofire

final class OnBoardingModel: ObservableObject {
    let didas = ["With our intuitive map and location-based search, you’ll never have to wander around looking for a restroom again.", "Share your experience by rating the toilets. Your reviews help others make informed decisions and encourage to maintain high standards.", "Follow other reviewers, comment on their posts, and exchange tips on finding the best restrooms. Together, we can make every toilet visit a pleasant one!", "You’re all set! Dive into T.P.T.G: Review and start exploring the best toilets around you. Happy toilet hunting!"]
    let titles = ["Find Toilets Near You", "Share Your Experiences", "Join the Community", "Start Exploring!"]
    @Published var position: String?
    @Published var navigateToLogInAndSignUp = false
    @Published var passwordVisibility = false
    @Published var username = ""
    @Published var firstName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var everithingOklog = true
    @Published var everithingOkreg = true
    @Published var otpOk = true
    @Published var otp = Array(repeating: "", count: 6)
    @Published var showErrorMail = false
    
    var emailIsValid: Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = email.range(
            of: emailPattern,
            options: .regularExpression
        )
        return result != nil
    }
    
    func nextButton(path: [String], completion: @escaping ([String]) -> Void) {
        var mutablePath = path
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                if let indexOfA = self.titles.firstIndex(of: self.position!) {
                    let nextIndex = indexOfA + 1
                    if nextIndex < self.titles.count {
                        self.position = self.titles[nextIndex]
                    } else {
                        mutablePath.append("ChoseLogM")
                        self.navigateToLogInAndSignUp = true
                    }
                }
                completion(mutablePath)
            }
        }
    }
    
    func doLogIn(path: [String], api: ApiManager, onBoarding: OnBoarding, completion: @escaping ([String]) -> Void) {
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
                        api.getUser { _ in
                            print("User ID saved")
                        }
                    }
                case .failure:
                    self.everithingOklog = false
                    self.resetValues()
                }
            }
        }
    }
    
    func doRegister(path: [String], api: ApiManager, completion: @escaping ([String]) -> Void) {
        let parameters = RegisterRequest(username: username, email: email, first_name: firstName, password: password, last_login: nil)
        var mutablePath = path
        print(parameters)
        api.createAccount(parameters: parameters) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    api.email = self.email
                    api.username = self.username
                    api.password = self.password
                    mutablePath.append("InsertOtp")
                    completion(mutablePath)
                case .failure:
                    self.everithingOkreg = false
                    self.resetValues()
                }
            }
        }
    }
    
    func insertOTP(path: [String], api: ApiManager, onBoarding: OnBoarding, completion: @escaping ([String]) -> Void) {
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
                                let renderer = ImageRenderer(content: ProfilePictureCustom()).uiImage
                                api.uploadProfilePicture(image: renderer!) { resp in
                                    print(resp)
                                }
                            case .failure:
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
    
    func resetValues() {
        username = ""
        firstName = ""
        email = ""
        password = ""
    }
    
  
    
}
