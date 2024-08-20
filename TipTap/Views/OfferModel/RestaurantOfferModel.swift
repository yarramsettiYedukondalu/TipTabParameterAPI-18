//
//  RestaurantOfferViewModel.swift
//  TipTap
//
//  Created by ToqSoft on 05/08/24.
//


import Foundation
struct OfferRecordModel: Codable {
    let partitionKey: String
    let rowKey: String
    let offerID: String
    let restaurantID: String
    let offerTitle: String?
    let description: String
    let discount: Double
    let startDate: String
    let endDate: String
    let offerImage: String
    let eTag: [String: String]
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case partitionKey = "PartitionKey"
        case rowKey = "RowKey"
        case offerID = "OfferID"
        case restaurantID = "RestaurantID"
        case offerTitle = "OfferTitle"
        case description = "Description"
        case discount = "Discount"
        case startDate = "startDate"
        case endDate = "EndDate"
        case offerImage = "offerImage"
        case eTag = "eTag"
        case timestamp = "timestamp"
    }
}

// MARK: - OfferResponse
struct OfferResponseModel: Codable {
    let records: [OfferRecordModel]
    let record: String?
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case records
        case record
        case statusCode
        case statusMessage
    }
}

// MARK: - RestaurantRecord
struct RestaurantRecord: Codable {
    let partitionKey: String
    let rowKey: String
    let restaurantID: String
    let restaurantTitle: String
    let restaurantAddress: String
    let city: String
    let state: String
    let zipCode: Int
    let restaurantPhone: Int
    let restaurantCategory: String
    let openingHours: String
    let isPromoted: Bool
    let restaurantImage: String
    let longitude: Double
    let latitude: Double
    let landMark: String
    let description: String
    let disable: Bool
    let eTag: [String: String]
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case partitionKey = "PartitionKey"
        case rowKey = "RowKey"
        case restaurantID = "RestaurantID"
        case restaurantTitle = "RestaurantTitle"
        case restaurantAddress = "RestaurantAddress"
        case city = "City"
        case state = "State"
        case zipCode = "ZipCode"
        case restaurantPhone = "RestaurantPhone"
        case restaurantCategory = "RestaurantCategory"
        case openingHours = "OpeningHours"
        case isPromoted = "IsPromoted"
        case restaurantImage = "RestaurantImage"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case landMark = "LandMark"
        case description = "Description"
        case disable = "Disable"
        case eTag = "eTag"
        case timestamp = "timestamp"
    }
}

// MARK: - RestaurantResponse
struct RestaurantResponses: Codable {
    let records: [RestaurantRecord]
    let record: String?
    let statusCode: Int
    let statusMessage: String
}

