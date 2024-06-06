import Foundation
import SwiftUI
import Alamofire

final class FeedModel: ObservableObject {
    @Published var feedToDisplay : [ResultFeed] = []
    
    
    func getFeedUpdated(api: ApiManager) {
        api.getFeed(id: api.userId) { resp in
            switch resp{
            case .success(let feed):
                self.feedToDisplay = feed.results
            case.failure(let error):
                print(error)
            }
        }
    }

    
}

