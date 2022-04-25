//
//  DataRow.swift
//  OpenSeaScraper
//
//  Created by Pietro on 18/04/22.
//

import Foundation

struct DataRow {
    let itemId: String
    let pricePercentageVariation: Double
    let initialPrice: Double
    let finalPrice: Double
    let token: String
    let saleDate: Date
    let itemCreationDate: Date
    let itemCreationDateInSecs: TimeInterval
    let isCollectionFeatured: Bool
    let collectionFloorPrice: Double
    let collectionAvaragePrice: Double
    let collectionItemsCount: Int
    let collectionOwnersCount: Int
    let sellerFee: Int
    let isSellerVerified: Bool
    let isCreatorVerified: Bool
    let discordMembersCount: Int
    let twitterFollowersCount: Int
}
