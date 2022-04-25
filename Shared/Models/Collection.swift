//
//  Collection.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

/// Can be not_requested (brand new collections), requested (collections that requested safelisting on our site), approved (collections that are approved on our site and can be found in search results), and verified (verified collections)
enum RequestStatus: String, Codable {
    case not_requested
    case requested
    case approved
    case verified
}

struct Collection: Codable {
    /// The collection name. Typically derived from the first contract imported to the collection but can be changed by the user
    let name: String
    /// External link to the original website for the collection
    let externalUrl: String?
    /// Description for the model
    let description: String?
    /// The collection slug that is used to link to the collection on OpenSea. This value can change by the owner but must be unique across all collection slugs in OpenSea
    let slug: String
    /// An image for the collection. Note that this is the cached URL we store on our end. The original image url is image_original_url
    let imageUrl: String?
    /// Image used in the horizontal top banner for the collection.
    let bannerImageUrl: String?
    /// The collector's fees that get paid out to them when sales are made for their collections
    let devSellerFeeBasisPoints: String // (Int)
    /// The collection's approval status within OpenSea.
    let safelistRequestStatus: RequestStatus
    /// The payout address for the collection's royalties
    let payoutAddress: String?
    
    // Not Documented
    let createdDate: Date
    let defaultToFiat: Bool
    let devBuyerFeeBasisPoints: String // (Int)
    let featured: Bool
    let hidden: Bool
    let twitterUsername: String?
    let discordUrl: String?
    
    // Only in Detailed Collection
    /// A dictionary containing some sales statistics related to this collection, including trade volume and floor prices
    let stats: Stats?
    let isSubjectToWhitelist: Bool?
    let onlyProxiedTransfers: Bool?
    let openseaBuyerFeeBasisPoints: String? // (Int)
    let openseaSellerFeeBasisPoints: String? // (Int)
    let requireEmail: Bool?
}
