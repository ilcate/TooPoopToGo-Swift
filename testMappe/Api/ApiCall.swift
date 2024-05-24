import Foundation
import SwiftUI
import Alamofire

class ApiManager: ObservableObject {
    @Published var userToken: String {
            didSet {
                UserDefaults.standard.set(userToken, forKey: "userToken")
                headers.update(name: "Authorization", value: "token \(userToken)")
            }
        }
    
    let url = "https://poop.zimahome.casa"
    var headers : HTTPHeaders
    
    // Mantieni un riferimento alla sessione come variabile di istanza
    private let session: Session
    
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
        self.headers = HTTPHeaders(["Authorization": "token \(UserDefaults.standard.string(forKey: "userToken") ?? "")"])
        
        // Initialize the session
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
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
                    completion(.success(responseString))
                case .failure(let error):
                    print("Failure: \(error)")
                    completion(.failure(error))
                }
            }
        
    }
    
    func searchBathroom(headers: HTTPHeaders, stringToSearch: String) {
        AF.request("\(url)/toilet/list-verified/\(stringToSearch)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseString):
                    print(responseString)
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
        
    }
    
    func getToken(userData: LogInInformation, completion: @escaping (Result<String, Error>) -> Void) {
        AF.request("\(url)/user/get-token", method: .post, parameters: userData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseBody):
                    
                    if let token = self.extractToken(from: responseBody) {
                        completion(.success(token))
                    }
                    
                case .failure(let error):
                    print("Failure: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func getBathroomsNearToYou(lat:CGFloat, long:CGFloat, distance: CGFloat, headers: HTTPHeaders, completion: @escaping (Result<[BathroomApi], Error>) -> Void) {
        AF.request("\(url)/toilet/list-from-point?distance=\(distance)&latitude=\(lat)&longitude=\(long)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [BathroomApi].self) { response in
                switch response.result {
                case .success(let responseBody):
                    completion(.success(responseBody))
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
    }
    
    private func extractToken(from jsonString: String) -> String? {
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
                    completion(.success(responseBody))
                case .failure(let error):
                    print("Failure: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    

    func createLocation(name: String, type: String, images: [UIImage], isForDisabled: Bool?, isFree: Bool?, isForBabies: Bool?, long: Double, lat: Double, userToken: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        
        var params: [String: String] = ["name": name, "type": type, "coordinates": "POINT (\(long) \(lat))"]
        
        if let isForDisabled = isForDisabled {
            params["is_for_disabled"] = isForDisabled ? "true" : "false"
        }
        if let isFree = isFree {
            params["is_free"] = isFree ? "true" : "false"
        }
        if let isForBabies = isForBabies {
            params["is_for_babies"] = isForBabies ? "true" : "false"
        }
        
        let url = "https://poop.zimahome.casa/toilet/create"
        let headers: HTTPHeaders = ["Authorization": "token \(userToken)"]
        
        session.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let data = value.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            for (index, img) in images.enumerated() {
                if let imageData = img.jpegData(compressionQuality: 0.5) {
                    let imageName = "\(name)_image\(index).jpeg"
                    multipartFormData.append(imageData, withName: "photos", fileName: imageName)
                }
            }
            
        }, to: url, method: .post, headers: headers).validate()
        .responseString { response in
            switch response.result {
            case .success(let apiResponse):
                do {
                    let responseData = Data(apiResponse.utf8)
                    let decodedResponse = try JSONDecoder().decode(RegisterResponse.self, from: responseData)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
}
