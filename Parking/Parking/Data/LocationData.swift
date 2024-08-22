//
//  LocationData.swift
//  Parking
//
//  Created by Kseniia Piskun on 20.08.2024.
//

//import Foundation
//import CoreLocation
//import MapKit
//
//struct LocationData: Codable {
//    let bounds: Bounds
//    let zones: [Zone]
//}
//
//struct Bounds: Codable {
//    let north: Double
//    let south: Double
//    let west: Double
//    let east: Double
//}
//
//struct Zone: Codable {
//    let id: String
//    let polygon: String
//    let name: String
//    let paymentIsAllowed: String
//    let maxDuration: String
//    let servicePrice: String
//    let depth: String
//    let draw: String
//    let stickerRequired: String
//    let currency: String
//    let contactEmail: String
//    let point: String
//    let country: String
//    let providerId: String
//    let providerName: String
//
//    var coordinates: [CLLocationCoordinate2D] {
//        return polygon.split(separator: ",").map { coordinateString in
//            let coords = coordinateString.split(separator: " ")
//            let latitude = Double(coords[0]) ?? 0.0
//            let longitude = Double(coords[1]) ?? 0.0
//            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        }
//    }
//
//    var polygonMK: MKPolygon {
//        return MKPolygon(coordinates: coordinates, count: coordinates.count)
//    }
//}
//

import Foundation
import CoreLocation
import MapKit

// Top-level struct representing the entire JSON structure
struct RootData: Codable {
    let currentLocation: String
    let locationData: LocationData

    // Map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case currentLocation = "current_location"
        case locationData = "location_data"
    }
}

// Struct representing the location data
struct LocationData: Codable {
    let bounds: Bounds
    let zones: [Zone]
}

struct Bounds: Codable {
    let north: Double
    let south: Double
    let west: Double
    let east: Double
}

struct Zone: Codable {
    let id: String
    let polygon: String
    let name: String
    let paymentIsAllowed: String
    let maxDuration: String
    let servicePrice: String
    let depth: String
    let draw: String
    let stickerRequired: String
    let currency: String
    let contactEmail: String
    let point: String
    let country: String
    let providerId: String
    let providerName: String

    enum CodingKeys: String, CodingKey {
        case id
        case polygon
        case name
        case paymentIsAllowed = "payment_is_allowed"
        case maxDuration = "max_duration"
        case servicePrice = "service_price"
        case depth
        case draw
        case stickerRequired = "sticker_required"
        case currency
        case contactEmail = "contact_email"
        case point
        case country
        case providerId = "provider_id"
        case providerName = "provider_name"
    }

    var coordinates: [CLLocationCoordinate2D] {
        return polygon.split(separator: ",").map { coordinateString in
            let coords = coordinateString.split(separator: " ")
            let latitude = Double(coords[0]) ?? 0.0
            let longitude = Double(coords[1]) ?? 0.0
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    var polygonMK: MKPolygon {
        return MKPolygon(coordinates: coordinates, count: coordinates.count)
    }
}
