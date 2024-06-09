import Foundation
import SwiftUI
import Alamofire
import PhotosUI


final class ProfileModel: ObservableObject{
    @Published var userInfo = UserInfoResponse(username: "Loading...", photo_user: "", id: "", friends_number: 0, badges: [], used_toilets: [])
    @Published var openSheetUploadImage = false
    @Published var photosPikerItems: [PhotosPickerItem] = []
    @Published var imagesNewAnnotation : [UIImage] = []
    @Published var userToilet : [BathroomApi] = []
    @Published var userRatings : [Review] = []
    @Published var userBadges : [BadgesInfo] = []
    
    func updateUserInfo(newUserInfo: UserInfoResponse) {
            DispatchQueue.main.async {
                self.userInfo = UserInfoResponse(username: newUserInfo.username, photo_user: newUserInfo.photo_user!.replacingOccurrences(of: "http://", with: "https://"), id: newUserInfo.id, friends_number: newUserInfo.friends_number, badges: newUserInfo.badges, used_toilets: newUserInfo.used_toilets)
            }
        }
    
    func getProfile(api: ApiManager) {
        api.getUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfoResponse):
                    if var photoUser = userInfoResponse.photo_user {
                        photoUser = photoUser.replacingOccurrences(of: "http://", with: "https://")
                        self.userInfo = UserInfoResponse(username: userInfoResponse.username, photo_user: photoUser, id: userInfoResponse.id, friends_number: userInfoResponse.friends_number, badges: userInfoResponse.badges, used_toilets: userInfoResponse.used_toilets)
                    } else {
                        self.userInfo = UserInfoResponse(username: userInfoResponse.username, photo_user: nil, id: userInfoResponse.id, friends_number: userInfoResponse.friends_number, badges: userInfoResponse.badges, used_toilets: userInfoResponse.used_toilets)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getReviews(api: ApiManager, isSelf: Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if isSelf {
                api.getSelfRatingsAdded{ res in
                    switch res{
                    case .success(let r):
                        self.userRatings = r
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            } else {
                api.getOtherRatingsAdded(id: self.userInfo.id){ res in
                    switch res{
                    case .success(let r):
                        self.userRatings = r
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            print(self.userRatings)
        }
    }
    
    func getBadges(api: ApiManager, isSelf: Bool){
        print("-------------")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if isSelf {
                api.getSelfBadgesCompleted{ res in
                    switch res{
                    case .success(let badges):
                        self.userBadges = badges
                        print( self.userBadges)
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                api.getUserBadgesCompleted(id: self.userInfo.id){ res in
                    switch res{
                    case .success(let badges):
                        self.userBadges = badges
                        print( self.userBadges)
                    case .failure(let error):
                        print(error)
                    }
                }
                
                
            }
            
        }
    }
    
    
    
    //TODO: non funziona
    func getToilets(api: ApiManager, isSelf: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            api.getToiletsAdded(string: isSelf ? "" : "/\(self.userInfo.id)") { result in
                switch result {
                case .success(let allBath):
                    DispatchQueue.main.async {
                        self.userToilet = allBath.map { bath in
                            BathroomApi(
                                id: bath.id,
                                photos: bath.photos,
                                name: bath.name,
                                address: bath.address,
                                coordinates: bath.coordinates,
                                place_type: bath.place_type,
                                is_for_disabled: bath.is_for_disabled,
                                is_free: bath.is_free,
                                is_for_babies: bath.is_for_babies,
                                tags: bath.tags,
                                updated_at: bath.updated_at
                            )
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

            
    }
    



