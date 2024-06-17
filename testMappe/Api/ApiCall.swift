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
        self.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    }
    
    @Published var username = ""
    @Published var password = ""
    @Published var email = ""
    @Published var userId = "" {
        didSet {
            UserDefaults.standard.set(userId, forKey: "userId")
        }
    }
    
    
    func createAccount(parameters: RegisterRequest, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        AF.request("\(url)/user/create", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserInfoResponse.self) { response in
                switch response.result {
                case .success(let data):
                    self.userId = data.id
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
    
    func getBathroomsNearToYou(lat: CGFloat, long: CGFloat, distance: CGFloat, completion: @escaping (Result<[BathroomApi], Error>) -> Void) {
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
    
    func getUser(completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        AF.request("\(url)/user/self-retrieve", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserInfoResponse.self) { response in
                switch response.result {
                case .success(let responseBody):
                    self.userId = responseBody.id
                    completion(.success(responseBody))
                case .failure(let error):
                    print("Failure: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func getReviews(idB: String, completion: @escaping (Result<[Review], Error>) -> Void) {
        AF.request("\(url)/toilet/list-toilet-ratings/\(idB)", method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ListOFRewievs.self) { response in
                    switch response.result {
                    case .success(let responseBody):
                        completion(.success(responseBody.results!))
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
        
        AF.upload(multipartFormData: { multipartFormData in
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
            
        }, to: "\(url)/toilet/create", method: .post, headers: headers)
            .validate()
            .responseDecodable(of: BathroomApi.self) { response in
                switch response.result {
                case .success(let responseBody):
                    completion(.success(responseBody))
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
    
    func getPoopStreak(completion: @escaping(Result<PoopStreak, Error>) -> Void) {
        AF.request("\(url)/poop-streak/get-poop-streak", method: .get, headers: headers)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: PoopStreak.self) { response in
                   switch response.result {
                   case .success(let poopStreak):
                       completion(.success(poopStreak))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
    }
    
    func updatePoopStreak(completion: @escaping(Result<PoopStreak, Error>) -> Void) {
        AF.request("\(url)/poop-streak/update-poop-streak", method: .patch, headers: headers)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: PoopStreak.self) { response in
                   switch response.result {
                   case .success(let poopStreak):
                       completion(.success(poopStreak))
                       print("Success: \(poopStreak)")
                   case .failure(let error):
                       completion(.failure(error))
                       print("Error: \(error)")
                   }
               }
    }
    
    func searchUser(stringToSearch: String, completion: @escaping (Result<[UserInfoResponse]?, Error>) -> Void) {
        AF.request("\(url)/user/search/\(stringToSearch)", method: .get, headers: headers)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: SearchUsers.self) { response in
                   switch response.result {
                   case .success(let searchedUsers):
                       completion(.success(searchedUsers.results))
                   case .failure(let error):
                       print("Error: \(error)")
                   }
               }
    }
    
    func getSpecificUser(userId: String, completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        AF.request("\(url)/user/retrieve/\(userId)", method: .get, headers: headers)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: UserInfoResponse.self) { response in
                   switch response.result {
                   case .success(let searchedUsers):
                       completion(.success(searchedUsers))
                   case .failure(let error):
                       print("Error: \(error)")
                   }
               }
    }
    
    func sendFriendRequest(userId: String) {
        AF.request("\(url)/user/add-friend/\(userId)", method: .post, headers: headers)
               .validate(statusCode: 200..<300)
               .responseString { response in
                   print(response)
               }
    }
    
    func acceptFriendRequest(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        AF.request("\(url)/user/accept-friend-request/\(userId)", method: .patch, headers: headers)
               .validate(statusCode: 200..<300)
               .responseString { response in
                   switch response.result {
                   case .success(let requestStatus):
                       completion(.success(true))
                   case .failure(let error):
                       completion(.success(false))
                   }
               }
    }
    
    func rejectFriendRequest(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        AF.request("\(url)/user/reject-friend-request/\(userId)", method: .patch, headers: headers)
               .validate(statusCode: 200..<300)
               .responseString { response in
                   switch response.result {
                   case .success(let requestStatus):
                       completion(.success(true))
                   case .failure(let error):
                       completion(.success(false))
                   }
               }
    }
    
    func removeFriend(userId: String) {
        AF.request("\(url)/user/remove-friend/\(userId)", method: .delete, headers: headers)
               .validate(statusCode: 200..<300)
               .responseString { response in
                   print(response)
               }
    }
    
    func statusFriendRequest(userId: String, completion: @escaping (Result<RequestStatus, Error>) -> Void) {
        AF.request("\(url)/user/friendship-status/\(userId)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RequestStatus.self) { response in
                print(response.result)
                switch response.result {
                case .success(let requestStatus):
                    completion(.success(requestStatus))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func getBadges(completion: @escaping (Result<[BadgesInfo], Error>) -> Void) {
        AF.request("\(url)/badge/list-all", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [BadgesInfo].self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getSpecificBadge(badgeId : String ,completion: @escaping (Result<BadgesInfoDetailed, Error>) -> Void) {
        AF.request("\(url)/badge/retrieve/\(badgeId)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BadgesInfoDetailed.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    

    
    func getMyFriends(completion: @escaping (Result<[UserInfoResponse], Error>) -> Void) {
        AF.request("\(url)/user/list-my-friends", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [UserInfoResponse].self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getOtherFriends(id: String, completion: @escaping (Result<[UserInfoResponse], Error>) -> Void) {
        AF.request("\(url)/user/list-user-friends/\(id)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [UserInfoResponse].self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    

    func getFeed(id: String, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        AF.request("\(url)/feed/list", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FeedResponse.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
        AF.request("\(url)/toilet/retrieve/\(id)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BathroomApi.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
        AF.request("\(url)/badge/list-completed-user-badges", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [BadgesInfo].self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func getUserBadgesCompleted(id: String,  completion: @escaping (Result<[BadgesInfo], Error>) -> Void) {
        AF.request("\(url)/badge/list-user-badges/\(id)", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [BadgesInfo].self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getTip(completion: @escaping (Result<[Tip], Error>) -> Void){
        AF.request("\(url)/user/list-tips", method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TipList.self) { response in
                switch response.result {
                case .success(let responseB):
                    completion(.success(responseB.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
