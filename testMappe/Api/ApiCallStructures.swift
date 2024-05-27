//
//  ApiCallStructures.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 18/05/24.
//

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


struct UserInfoResponse: Decodable {
    var username: String
    var id: String
    var friends_number: Int
    var badges: [String]
    var used_toilets: [String]
}


struct SearchBath: Decodable{
    var results : [BathroomApi]?
}

import Foundation

struct BathroomApi: Decodable, Identifiable, Equatable, Hashable {
    var id: String?
    var photos: [Photos]?
    var name: String?
    var address: String?
    var coordinates: Coordinates?
    var place_type: String?
    var is_for_disabled: Bool?
    var is_free: Bool?
    var is_for_babies: Bool?
    var tags: BathroomTags?
    var created_at: String?

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
        created_at: String? = nil
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
        self.created_at = created_at

        let dateFormatter = ISO8601DateFormatter()
        let createdAtDate = dateFormatter.date(from: created_at ?? "")
        let newest = createdAtDate.map { Calendar.current.isDate($0, equalTo: Date(), toGranularity: .day) } ?? false

        self.tags = tags ?? BathroomTags(
            free: is_free ?? false,
            accessible: is_for_disabled ?? false,
            forBabies: is_for_babies ?? false,
            newest: newest,
            isPublic: place_type == "Public",
            isBar: place_type == "Bar",
            isRestaurant: place_type == "Restaurant",
            isShop: place_type == "Shop"
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
               lhs.created_at == rhs.created_at
    }

    private var properties: [(String, Any?)] {
        return [
            ("id", id),
            ("name", name),
            ("address", address),
            ("coordinates", coordinates),
            ("place_type", place_type),
            ("is_for_disabled", is_for_disabled),
            ("is_free", is_free),
            ("is_for_babies", is_for_babies),
            ("photos", photos),
            ("created_at", created_at)
        ]
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
        hasher.combine(created_at)
    }
}

struct BathroomTags: Decodable, Equatable, Hashable {
    var free: Bool
    var accessible: Bool
    var forBabies: Bool
    var newest: Bool
    var isPublic: Bool
    var isBar: Bool
    var isRestaurant: Bool
    var isShop: Bool

    init(
        free: Bool = false,
        accessible: Bool = false,
        forBabies: Bool = false,
        newest: Bool = false,
        isPublic: Bool = false,
        isBar: Bool = false,
        isRestaurant: Bool = false,
        isShop: Bool = false
    ) {
        self.free = free
        self.accessible = accessible
        self.forBabies = forBabies
        self.newest = newest
        self.isPublic = isPublic
        self.isBar = isBar
        self.isRestaurant = isRestaurant
        self.isShop = isShop
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
