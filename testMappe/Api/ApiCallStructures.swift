import Foundation

struct RegisterRequest: Encodable {
    let username: String
    let email: String
    let first_name: String
    let password: String
    let last_login: [String]?
}

struct RegisterResponse: Decodable {
    let message: String?
    let last_login: [String]?
}

struct SendOtp: Encodable{
    let otp : String
    let email : String
}

struct LogInInformation: Encodable{
    let username : String
    let password : String
}


struct UserInfoResponse: Decodable, Identifiable, Hashable {
    var username: String
    var photo_user: String?
    var id: String
    var friends_number: Int?
    var badges: [String]?
    var used_toilets: [String]?
}

struct ListOFRewievs: Decodable {
    var results: [Review]?
}

struct UserRev: Decodable, Equatable, Hashable {
    var photo_user: String?
    var username: String
    var id: String
}

struct Review: Decodable, Identifiable, Equatable, Hashable {
    let cleanlinessRating: String
    let comfortRating: String
    let accessibilityRating: String
    let review: String
    let id: String
    let user: UserRev
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case cleanlinessRating = "cleanliness_rating"
        case comfortRating = "comfort_rating"
        case accessibilityRating = "accessibility_rating"
        case review
        case id
        case user
        case createdAt = "created_at"
    }

    
    static func ==(lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id &&
               lhs.cleanlinessRating == rhs.cleanlinessRating &&
               lhs.comfortRating == rhs.comfortRating &&
               lhs.accessibilityRating == rhs.accessibilityRating &&
               lhs.review == rhs.review &&
               lhs.user == rhs.user &&
               lhs.createdAt == rhs.createdAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cleanlinessRating)
        hasher.combine(comfortRating)
        hasher.combine(accessibilityRating)
        hasher.combine(review)
        hasher.combine(user)
        hasher.combine(createdAt)
    }
}

struct SearchBath: Decodable{
    var results : [BathroomApi]?
}


struct BathroomApi: Decodable, Identifiable, Equatable, Hashable {
    var id: String?
    var photos: [Photos]?
    var name: String?
    var updated_at: String?
    var address: String?
    var coordinates: Coordinates?
    var place_type: String?
    var is_for_disabled: Bool?
    var is_free: Bool?
    var is_for_babies: Bool?
    var tags: BathroomTags?
    
    init(
        id: String? = nil,
        photos: [Photos]? = nil,
        name: String? = nil,
        address: String? = nil,
        coordinates: Coordinates? = nil,
        place_type: String? = nil,
        is_for_disabled: Bool? = nil,
        is_free: Bool? = nil,
        is_for_babies: Bool? = nil,
        tags: BathroomTags? = nil,
        updated_at: String? = nil
    ) {
        self.id = id
        self.photos = photos
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.place_type = place_type
        self.is_for_disabled = is_for_disabled
        self.is_free = is_free
        self.is_for_babies = is_for_babies
        self.updated_at = updated_at
        
        let dateFormatter = DateFormatter()
        var isNew = false
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let current_date = Date()
        if let updatedAtString = updated_at, let update_date = dateFormatter.date(from: updatedAtString) {
            if current_date.timeIntervalSince(update_date) <= 24 * 60 * 60 {
                isNew = true
            }
        }
        
        self.tags = tags ?? BathroomTags(
            free: is_free ?? false,
            accessible: is_for_disabled ?? false,
            forBabies: is_for_babies ?? false,
            newest: isNew
        )
    }
    
    var identifier: String {
        id ?? UUID().uuidString
    }
    
    static func == (lhs: BathroomApi, rhs: BathroomApi) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.coordinates == rhs.coordinates &&
        lhs.place_type == rhs.place_type &&
        lhs.is_for_disabled == rhs.is_for_disabled &&
        lhs.is_free == rhs.is_free &&
        lhs.is_for_babies == rhs.is_for_babies &&
        lhs.photos == rhs.photos &&
        lhs.tags == rhs.tags &&
        lhs.updated_at == rhs.updated_at
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(address)
        hasher.combine(coordinates)
        hasher.combine(place_type)
        hasher.combine(is_for_disabled)
        hasher.combine(is_free)
        hasher.combine(is_for_babies)
        hasher.combine(photos)
        hasher.combine(tags)
        hasher.combine(updated_at)
    }
}

struct BathroomTags: Decodable, Equatable, Hashable {
    var free: Bool
    var accessible: Bool
    var forBabies: Bool
    var newest: Bool
    
    init(
        free: Bool = false,
        accessible: Bool = false,
        forBabies: Bool = false,
        newest: Bool = false
    ) {
        self.free = free
        self.accessible = accessible
        self.forBabies = forBabies
        self.newest = newest
    }
}

struct Photos: Decodable, Equatable, Hashable {
    var id: String?
    var photo: String?
}

struct Coordinates: Decodable, Equatable, Hashable {
    var type: String?
    var coordinates: [Double]?
    
    static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.type == rhs.type && lhs.coordinates == rhs.coordinates
    }
}


struct addApiResponse: Decodable {
    let success: Bool
    let message: String?
}

struct AddRating: Encodable {
    let cleanliness_rating: Int?
    let comfort_rating: Int?
    let accessibility_rating: Int?
    let review : String?
}

struct GetRatingStats: Decodable {
    let overall_rating: String
    let cleanliness_rating: String
    let comfort_rating: String
    let accessibility_rating: String
    let review_count : Int
}


struct PoopStreak: Decodable {
    let streak_status: String
    let poop_count: Int
}

struct RequestStatus: Decodable {
    let request_status: String
}


struct SearchUsers: Decodable {
    let results: [UserInfoResponse]?
}



struct BadgesInfo: Decodable , Hashable {
    let badge_id : String
    let badge_name : String
    var badge_photo : String?
    let is_completed : Bool
    let date_completed : String?
    let completion : Int
}


struct BadgesInfoDetailed: Decodable {
    let name : String
    var description : String
    let badge_requirement_threshold : Int
    let badge_photo : String
}

struct GetFeed: Decodable {
    let result : [Feed]
}

struct Feed: Decodable{
    var ciao : String
    var miao : String
}




struct FeedResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ResultFeed]
}

struct ResultFeed: Decodable, Identifiable {
    let id: String
    let created_at: String
    let updated_at: String
    let content: String
    let content_type: String
    let badge: BadgeFeed?
    let toilet: ToiletFeed?
    let friend_request: FriendRequestFeed?
    let user: String
}

struct BadgeFeed: Decodable {
    let id: String
    let badge_name: String
    let badge_photo: String?

}

struct FriendRequestFeed: Decodable {
    let id: String
    let from_user: String
    let to_user: String
    let request_status: String
}

struct ToiletFeed: Decodable {
    let id: String
    let name: String

}

struct HasRated: Decodable {
    let has_rated : Bool

}
