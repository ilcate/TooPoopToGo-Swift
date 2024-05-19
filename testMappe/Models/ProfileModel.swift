import Foundation
import SwiftUI
import Alamofire

final class ProfileModel: ObservableObject{
    @Published var userInfo = UserInfoResponse(username: "Loading...", id: "", friends_number: 0, badges: [], used_toilets: [])
    
    
    func getProfile(api : ApiManager){
        print(api.userToken)
        let headers = HTTPHeaders(["Authorization": "token \(api.userToken)"])
        api.getUser(headers: headers){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfoResponse):
                    self.userInfo =  UserInfoResponse(username: userInfoResponse.username, id: userInfoResponse.id, friends_number: userInfoResponse.friends_number, badges: userInfoResponse.badges, used_toilets: userInfoResponse.used_toilets)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
