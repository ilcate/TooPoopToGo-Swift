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
    let components = address.components(separatedBy: ",")
    
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


func timeElapsedSince(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = dateFormatter.date(from: dateString) else {
        return "Invalid Date"
    }
    
    let elapsedTime = Date().timeIntervalSince(date)
    let hours = elapsedTime / 3600
    let days = elapsedTime / 86400
    
    if days >= 1 {
        if Int(days) == 1 {
            return "1 day ago"
        } else {
            return "\(Int(days)) days ago"
        }
    } else {
        if Int(hours) == 1 {
            return "1 hour ago"
        } else {
            return "\(Int(hours)) hours ago"
        }
    }
}
