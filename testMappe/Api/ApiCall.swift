import Foundation
import Alamofire


class ApiManager: ObservableObject {
    @Published var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "userToken")
        }
    }
    private var url = "https://poop.zimahome.casa"
    
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    
    
    func createAccount(parameters: RegisterRequest) {
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
                    if let token = self.extractCode(from: responseBody) {
                        self.saveToken(token: token)
                    }
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
    }
    
    private func extractCode(from jsonString: String) -> String? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let token = jsonObject["token"] as? String {
                return String(token.prefix(40))
            }
        } catch {
            print("Errore durante il parsing JSON: \(error)")
        }
        
        return nil
    }
    
    private func saveToken(token: String) {
        self.userToken = token
        UserDefaults.standard.set(token, forKey: "userToken")
    }
    
    func clearToken() {
        self.userToken = ""
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
    
    func getUser(headers: HTTPHeaders, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
            AF.request("\(url)/user/self-retrieve", method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserInfoResponse.self) { response in
                    switch response.result {
                    case .success(let responseBody):
                        print("Response Body: \(responseBody)")
                        completion(.success(responseBody))
                    case .failure(let error):
                        print("Failure: \(error)")
                        completion(.failure(error))
                    }
                }
        }
    
}
