//
//  Structures.swift
//  ToPoopToGoWatch Watch App
//
//  Created by Christian Catenacci on 31/05/24.
//

import Foundation

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

