//
//  Functions.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 25/05/24.
//

import Foundation

func formatAddress(_ address: String) -> String {
    if address == "" {
        return "No address provided"
    }
    var components = address.components(separatedBy: ",")
    
    if components.count > 3 {
        let formattedAddress = "\(components[1]), \(components[2]), \(components[4])"
        return formattedAddress
    } else if components.count == 3 {
        let comp = components[1].components(separatedBy: " ")
        let formattedAddress = "\(components[0]), \(comp[2]), \(components[2])"
        return formattedAddress
    }else {
        return "No address provided"
    }
}

func getStreet(_ address: String) -> String {
    if address == "" {
        return "No street provided"
    }
    let components = address.components(separatedBy: ",")    
    if components.count > 3 {
        let formattedAddress = "\(components[1])"
        return formattedAddress
    }
    if components.count == 3 {
        let formattedAddress = "\(components[0])"
        return formattedAddress
    } else {
        return "No address provided"
    }
}

