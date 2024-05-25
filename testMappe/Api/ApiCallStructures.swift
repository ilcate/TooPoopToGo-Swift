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
    
    //devo chiedere ad ale perché esistono
//    let message: String?
//    let last_login: [String]?
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

struct BathroomApi: Decodable, Identifiable, Equatable {
    var id: String?
    var photos: [Photos]?
    var name: String?
    var address: String?
    var coordinates: Coordinates?
    var place_type: String?
    var is_for_disabled: Bool?
    var is_free: Bool?
    var is_for_babies: Bool?

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
               lhs.photos == rhs.photos
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
            ("photos", photos)
        ]
    }
}

struct Photos: Decodable, Equatable, Hashable {
    var id: String?
    var photo: String?
}

struct Coordinates: Decodable, Equatable {
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
