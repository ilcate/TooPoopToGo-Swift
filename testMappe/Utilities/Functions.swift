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
    let minutes = elapsedTime / 60
    let hours = elapsedTime / 3600
    let days = elapsedTime / 86400
    let weeks = elapsedTime / (86400 * 7)
    
    if weeks >= 1 {
        if Int(weeks) == 1 {
            return "1 week ago"
        } else {
            return "\(Int(weeks)) weeks ago"
        }
    } else if days >= 1 {
        if Int(days) == 1 {
            return "1 day ago"
        } else {
            return "\(Int(days)) days ago"
        }
    } else if hours >= 1 {
        if Int(hours) == 1 {
            return "1 hour ago"
        } else {
            return "\(Int(hours)) hours ago"
        }
    } else {
        if Int(minutes) == 1 {
            return "1 minute ago"
        } else {
            return "\(Int(minutes)) minutes ago"
        }
    }
}


func getBathroomTags(bathroom : BathroomApi) -> [Bool]{
    return [
        bathroom.tags!.accessible ? true : false,
        bathroom.tags!.free ? true : false,
        bathroom.tags!.forBabies ? true : false,
        bathroom.tags!.newest ? true : false,
        bathroom.place_type?.capitalized == "Public" ? true : false,
        bathroom.place_type?.capitalized == "Shop" ? true : false,
        bathroom.place_type?.capitalized == "Restaurant" ? true : false,
        bathroom.place_type?.capitalized == "Bar" ? true : false,
    ]
}


func getAvg(review: Review) -> String {
    if let floatValue1 = Float(review.accessibilityRating), let floatValue2 = Float(review.cleanlinessRating) , let floatValue3 = Float(review.comfortRating){
        let average = (floatValue1 + floatValue2 + floatValue3) / 3.0
        return String(format: "%.2f", average)
    } else {
        return "0"
    }
}
