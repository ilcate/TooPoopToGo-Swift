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

