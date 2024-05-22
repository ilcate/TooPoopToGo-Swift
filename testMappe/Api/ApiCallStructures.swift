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

struct BathroomApi: Decodable {
    var id: String?
    var name: String?
    var address: String?
    var coordinates: Coordinates?
    var place_type: String?
    var is_for_disabled : Bool?
    var is_free: Bool?
    var is_for_babies: Bool?
}

struct Coordinates: Decodable {
    var type: String?
    var coordinates: [Double]?
}
