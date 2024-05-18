import Foundation
import Alamofire


class ApiManager: ObservableObject {
    @Published var userToken: String {
            didSet {
                UserDefaults.standard.set(userToken, forKey: "userToken")
            }
        }
    var url = "https://poop.zimahome.casa"
    
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    
            
    
    func createAccount() {
        let parameters = RegisterRequest(username: "chri", email: "kryscc03@gmail.com", first_name: "christian", password: "password", last_login: nil)
        
        AF.request("\(url)/user/create", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("Success: \(data)")
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
        
        //TODO: gestire meglio gli errori a schermo
    }
    
    func activateAccount(parameters: SendOtp) {
        
        AF.request("\(url)/user/activate", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let responseString):
                    print("Response String: \(responseString)")
                    let loginInfo = LogInInformation(username: "chri", password: "password")
                    self.getToken(userData: loginInfo)
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
            
    }
    
    func getToken(userData: LogInInformation) {
        AF.request("\(url)/user/get-token", method: .post, parameters: userData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseBody):
                    print("Response String: \(responseBody)")
                    self.saveToken(token: responseBody)
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
            
    }
    
    private func saveToken(token: String) {
        self.userToken = token
        UserDefaults.standard.set(token, forKey: "userToken")
    }
    
    func clearToken() {
        self.userToken = ""
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
}
