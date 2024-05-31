import Foundation
import SwiftUI
import Alamofire

class ApiManagerWatch: ObservableObject {
    @Published var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "userToken")
            headers.update(name: "Authorization", value: "token \(userToken)")
        }
    }
    
    let url = "https://poop.zimahome.casa"
    var headers: HTTPHeaders
    
    init() {
        self.userToken = "1d76f34e0fde9110da6de05f6be3de9bc87bdb1f"
        self.headers = HTTPHeaders(["Authorization": "token  1d76f34e0fde9110da6de05f6be3de9bc87bdb1f"])
    }
    
    @Published var username = ""
    @Published var password = ""
    @Published var email = ""
    
    
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
    
    
}
