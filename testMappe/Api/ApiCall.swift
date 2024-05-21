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
    
    @Published var username = ""
    @Published var password = ""
    @Published var email = ""
    
    
    func createAccount(parameters: RegisterRequest, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        AF.request("\(url)/user/create", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func activateAccount(parameters: SendOtp, completion: @escaping (Result<String, Error>) -> Void) {
        AF.request("\(url)/user/activate", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseString):
                    print("Response String: \(responseString)")
                    completion(.success(responseString))
                case .failure(let error):
                    print("Failure: \(error)")
                    completion(.failure(error))
                }
            }
        
    }
    
    func getToken(userData: LogInInformation, completion: @escaping (Result<String, Error>) -> Void) {
        AF.request("\(url)/user/get-token", method: .post, parameters: userData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseBody):
                    print("Response String: \(responseBody)")
                    
                    if let token = self.extractCode(from: responseBody) {
                        completion(.success(token))
                    }
                    
                case .failure(let error):
                    print("Failure: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func getBathrooms(lat:CGFloat, long:CGFloat, distance: CGFloat, headers: HTTPHeaders) {
        AF.request("\(url)/toilet/list-from-point?distance=\(distance)&latitude=\(lat)&longitude=\(long)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseBody):
                    print("Response String: \(responseBody)")
                    
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
    }
    //da finire
    
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
    
    func saveToken(token: String) {
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
    // questo codice dovrebbe essere usato per mandare le immagini
    //    func uploadImage(imgType:String,imgData:Data,imageName:String){
    //       // params to send additional data, for eg. AccessToken or userUserId
    //       let params = ["userID":"userId","accessToken":"your accessToken"]
    //       print(params)
    //       AF.upload(multipartFormData: { multiPart in
    //           for (key,keyValue) in params{
    //               if let keyData = keyValue.data(using: .utf8){
    //                   multiPart.append(keyData, withName: key)
    //               }
    //           }
    //
    //           multiPart.append(imgData, withName: "key",fileName: imageName,mimeType: "image/*")
    //       }, to: "Your URL",headers: []).responseJSON { apiResponse in
    //
    //           switch apiResponse.result{
    //           case .success(_):
    //               let apiDictionary = apiResponse.value as? [String:Any]
    //               print("apiResponse --- \(apiDictionary)")
    //           case .failure(_):
    //               print("got an error")
    //           }
    //       }
    //   }
    
}
