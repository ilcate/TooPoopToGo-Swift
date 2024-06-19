import Foundation
import SwiftUI
import Alamofire

final class FeedModel: ObservableObject {
    @Published var feedToDisplay : [ResultFeed] = []
    
    
    func getFeedUpdated(api: ApiManager) {
        api.getFeed(id: api.personalId) { resp in
            switch resp{
            case .success(let feed):
                self.feedToDisplay = feed.results!
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func rejectFriendRequest(api: ApiManager, id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        api.rejectFriendRequest(userId: id) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func acceptFriendRequest(api: ApiManager, id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        api.acceptFriendRequest(userId: id) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    
    func getSpecificBathroom(api: ApiManager, id : String, completion: @escaping (Result<BathroomApi, Error>) -> Void) {
        api.getSingleBathroom(id: id) { resp in
            switch resp {
            case .success(let responseB):
                completion(.success(responseB))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    
}

