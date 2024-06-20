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
    var headers: HTTPHeaders
    
    init() {
        self.userToken = UserDefaults.standard.string(forKey: "userToken") ?? ""
        self.headers = HTTPHeaders(["Authorization": "token \(UserDefaults.standard.string(forKey: "userToken") ?? "")"])
        self.personalId = UserDefaults.standard.string(forKey: "userId") ?? ""
    }
    
    @Published var username = ""
    @Published var password = ""
    @Published var email = ""
    @Published var personalId = "" {
        didSet {
            UserDefaults.standard.set(personalId, forKey: "userId")
        }
    }
    
    func saveToken(token: String) {
        self.userToken = token
        UserDefaults.standard.set(token, forKey: "userToken")
    }

    func clearToken() {
        self.userToken = ""
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
    
    func performUploadRequest<T: Decodable>(endpoint: String, parameters: [String: String], images: [UIImage], completion: @escaping (Result<T, Error>) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = value.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            for (index, img) in images.enumerated() {
                if let imageData = img.jpegData(compressionQuality: 0.5) {
                    let imageName = "image\(index).jpeg"
                    multipartFormData.append(imageData, withName: "photos", fileName: imageName)
                }
            }
        }, to: "\(url)/\(endpoint)", method: .post, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .responseSerializationFailed(let reason):
                        switch reason {
                        case .decodingFailed(let decodingError):
                            print("Decoding Error: \(decodingError)")
                        default:
                            print("Serialization Error: \(reason)")
                        }
                    case .responseValidationFailed(let reason):
                        print("Validation Error: \(reason)")
                    default:
                        print("AF Error: \(afError)")
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    func performGetRequest<T: Decodable>(endpoint: String, parameters: Parameters? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request("\(url)/\(endpoint)", method: .get, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let afError = error.asAFError {
                        switch afError {
                        case .responseSerializationFailed(let reason):
                            switch reason {
                            case .decodingFailed(let decodingError):
                                print("Decoding Error: \(decodingError)")
                            default:
                                print("Serialization Error: \(reason)")
                            }
                        case .responseValidationFailed(let reason):
                            print("Validation Error: \(reason)")
                        default:
                            print("AF Error: \(afError)")
                        }
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func performPostRequest<T: Codable>(endpoint: String, parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request("\(url)/\(endpoint)", method: .post, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let afError = error.asAFError {
                        switch afError {
                        case .responseSerializationFailed(let reason):
                            switch reason {
                            case .decodingFailed(let decodingError):
                                print("Decoding Error: \(decodingError)")
                            default:
                                print("Serialization Error: \(reason)")
                            }
                        case .responseValidationFailed(let reason):
                            print("Validation Error: \(reason)")
                        default:
                            print("AF Error: \(afError)")
                        }
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func performPatchRequest<T: Codable>(endpoint: String, parameters: Parameters? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request("\(url)/\(endpoint)", method: .patch, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let afError = error.asAFError {
                        switch afError {
                        case .responseSerializationFailed(let reason):
                            switch reason {
                            case .decodingFailed(let decodingError):
                                print("Decoding Error: \(decodingError)")
                            default:
                                print("Serialization Error: \(reason)")
                            }
                        case .responseValidationFailed(let reason):
                            print("Validation Error: \(reason)")
                        default:
                            print("AF Error: \(afError)")
                        }
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func performDeleteRequest<T: Decodable>(endpoint: String, parameters: Parameters? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request("\(url)/\(endpoint)", method: .delete, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let afError = error.asAFError {
                        switch afError {
                        case .responseSerializationFailed(let reason):
                            switch reason {
                            case .decodingFailed(let decodingError):
                                print("Decoding Error: \(decodingError)")
                            default:
                                print("Serialization Error: \(reason)")
                            }
                        case .responseValidationFailed(let reason):
                            print("Validation Error: \(reason)")
                        default:
                            print("AF Error: \(afError)")
                        }
                    }
                    completion(.failure(error))
                }
            }
    }

    func createAccount(parameters: RegisterRequest, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        AF.request("\(url)/user/create", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserInfoResponse.self) { response in
                switch response.result {
                case .success(let data):
                    self.personalId = data.id
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

    func searchBathroom(stringToSearch: String, completion: @escaping (Result<[BathroomApi]?, Error>) -> Void) {
        AF.request("\(url)/toilet/list-verified/\(stringToSearch)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchBath.self) { response in
                switch response.result {
                case .success(let responseS):
                    completion(.success(responseS.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    func uploadProfilePicture(image: UIImage, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    multipartFormData.append(imageData, withName: "photo_user", fileName: "photo_user.jpg")
                }
            }, to: "\(url)/user/self-update", method: .patch, headers: headers)
            .validate()
            .responseDecodable(of: UserInfoResponse.self) { response in
                switch response.result {
                case .success(let responseString):
                    completion(.success(responseString))
                    print("Success: \(responseString)")
                case .failure(let error):
                    print("Error: \(error)")
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
    func getBathroomsNearToYou(lat: CGFloat, long: CGFloat, distance: CGFloat, completion: @escaping (Result<[BathroomApi], Error>) -> Void) {
        let params: Parameters = [
            "distance": distance,
            "latitude": lat,
            "longitude": long
        ]
        performGetRequest(endpoint: "toilet/list-from-point", parameters: params, completion: completion)
    }

    func getUser(completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        performGetRequest(endpoint: "user/self-retrieve", completion: completion)
    }

    func getReviews(idB: String, completion: @escaping (Result<ListOFRewievs, Error>) -> Void) {
        AF.request("\(url)/toilet/list-toilet-ratings/\(idB)", method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ListOFRewievs.self) { response in
                    switch response.result {
                    case .success(let responseBody):
                        completion(.success(responseBody))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
    }

    
    func addReview(idB: String, parameters: AddRating) {
        AF.request("\(url)/user/create-rating/\(idB)", method: .post, parameters: parameters, headers: headers )
                .validate(statusCode: 200..<300)
                .responseString{ resp in
                    print(resp)
                }
    }

    func getRevStats(idB: String, completion: @escaping (Result<GetRatingStats, Error>) -> Void) {
        AF.request("\(url)/toilet/retrieve-toilet-rating/\(idB)", method: .get, headers: headers )
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GetRatingStats.self){ response in
                    switch response.result {
                    case .success(let responseBody):

                        completion(.success(responseBody))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
    }


    func createLocation(name: String, type: String, images: [UIImage], isForDisabled: Bool?, isFree: Bool?, isForBabies: Bool?, long: Double, lat: Double, completion: @escaping (Result<BathroomApi, Error>) -> Void) {
        var params: [String: String] = ["name": name, "place_type": type, "coordinates": "POINT (\(long) \(lat))"]
        if let isForDisabled = isForDisabled {
            params["is_for_disabled"] = isForDisabled ? "true" : "false"
        }
        if let isFree = isFree {
            params["is_free"] = isFree ? "true" : "false"
        }
        if let isForBabies = isForBabies {
            params["is_for_babies"] = isForBabies ? "true" : "false"
        }
        performUploadRequest(endpoint: "toilet/create", parameters: params, images: images, completion: completion)
    }

    

    func getPoopStreak(completion: @escaping(Result<PoopStreak, Error>) -> Void) {
        performGetRequest(endpoint: "poop-streak/get-poop-streak", completion: completion)
    }

    func updatePoopStreak(completion: @escaping(Result<PoopStreak, Error>) -> Void) {
        performPatchRequest(endpoint: "poop-streak/update-poop-streak", completion: completion)
    }

    func searchUser(stringToSearch: String, completion: @escaping (Result<SearchUsers, Error>) -> Void) {
        performGetRequest(endpoint: "user/search/\(stringToSearch)", completion: completion)
    }

    func getSpecificUser(userId: String, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        performGetRequest(endpoint: "user/retrieve/\(userId)", completion: completion)
    }

    func sendFriendRequest(userId: String) {
        performPostRequest(endpoint: "user/add-friend/\(userId)", parameters: [:]) { (result: Result<String, Error>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

    func acceptFriendRequest(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        AF.request("\(url)/user/accept-friend-request/\(userId)", method: .patch, headers: headers)
               .validate(statusCode: 200..<300)
               .responseString { response in
                   switch response.result {
                   case .success:
                       completion(.success(true))
                   case .failure:
                       completion(.success(false))
                   }
               }
    }

    func rejectFriendRequest(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        AF.request("\(url)/user/reject-friend-request/\(userId)", method: .patch, headers: headers)
               .validate(statusCode: 200..<300)
               .responseString { response in
                   switch response.result {
                   case .success:
                       completion(.success(true))
                   case .failure:
                       completion(.success(false))
                   }
               }
    }

    func removeFriend(userId: String) {
        performDeleteRequest(endpoint: "user/remove-friend/\(userId)") { (result: Result<String, Error>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

    func statusFriendRequest(userId: String, completion: @escaping (Result<RequestStatus, Error>) -> Void) {
        performGetRequest(endpoint: "user/friendship-status/\(userId)", completion: completion)
    }

    func getBadges(completion: @escaping (Result<[BadgesInfo], Error>) -> Void) {
        performGetRequest(endpoint: "badge/list-all", completion: completion)
    }

    func getSpecificBadge(badgeId : String ,completion: @escaping (Result<BadgesInfoDetailed, Error>) -> Void) {
        performGetRequest(endpoint: "badge/retrieve/\(badgeId)", completion: completion)
    }

    func getMyFriends(completion: @escaping (Result<[UserInfoResponse], Error>) -> Void) {
        performGetRequest(endpoint: "user/list-my-friends", completion: completion)
    }

    func getOtherFriends(id: String, completion: @escaping (Result<[UserInfoResponse], Error>) -> Void) {
        performGetRequest(endpoint: "user/list-user-friends/\(id)", completion: completion)
    }

    func getFeed(id: String, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        performGetRequest(endpoint: "feed/list", completion: completion)
    }

    func getHasRated(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        AF.request("\(url)/toilet/user-has-rated/\(id)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: HasRated.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB.has_rated))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


    func getSingleBathroom(id: String, completion: @escaping (Result<BathroomApi, Error>) -> Void) {
        performGetRequest(endpoint: "toilet/retrieve/\(id)", completion: completion)
    }

    func getToiletsAdded(string: String, completion: @escaping (Result<[BathroomApi], Error>) -> Void) {
        AF.request("\(url)/toilet/list-user-toilets\(string)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchBath.self) { response in
                switch response.result {
                case .success(let responseB):
                    print(responseB)
                    completion(.success(responseB.results ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func getSelfRatingsAdded(completion: @escaping (Result<[Review], Error>) -> Void) {
        AF.request("\(url)/user/list-self-user-ratings", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ListOFRewievs.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB.results ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func getOtherRatingsAdded(id: String, completion: @escaping (Result<[Review], Error>) -> Void) {
        AF.request("\(url)/user/list-user-ratings/\(id)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ListOFRewievs.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB.results ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


    func getSelfBadgesCompleted( completion: @escaping (Result<[BadgesInfo], Error>) -> Void) {
        performGetRequest(endpoint: "badge/list-completed-user-badges", completion: completion)
    }

    func getUserBadgesCompleted(id: String,  completion: @escaping (Result<[BadgesInfo], Error>) -> Void) {
        performGetRequest(endpoint: "badge/list-user-badges/\(id)", completion: completion)
    }

    func getTip(completion: @escaping (Result<TipList, Error>) -> Void){
        performGetRequest(endpoint: "user/list-tips", completion: completion)
    }

    func getRatingsOfFriends(completion: @escaping (Result<[Review], Error>) -> Void) {
        AF.request("\(url)/user/list-friends-ratings", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ListOFRewievs.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB.results ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

// Helper Extensions for Parameter Conversion
extension RegisterRequest {
    func toParameters() -> Parameters {
        return [
            "username": self.username,
            "email": self.email,
            "first_name": self.first_name,
            "password": self.password,
            "last_login": self.last_login ?? []
        ]
    }
}

extension SendOtp {
    func toParameters() -> Parameters {
        return [
            "otp": self.otp,
            "email": self.email
        ]
    }
}

extension LogInInformation {
    func toParameters() -> Parameters {
        return [
            "username": self.username,
            "password": self.password
        ]
    }
}

extension AddRating {
    func toParameters() -> Parameters {
        return [
            "cleanliness_rating": self.cleanliness_rating ?? 0,
            "comfort_rating": self.comfort_rating ?? 0,
            "accessibility_rating": self.accessibility_rating ?? 0,
            "review": self.review ?? ""
        ]
    }
}
