//
//  Asset.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

struct Asset: Codable {
    /// The token ID of the NFT
    let tokenId: String
    /// Name of the item
    let name: String?
    /// Dictionary of data on the contract itself
    let assetContract: Contract
    
    // Not Documented
    let numSales: Int
    let permalink: String
    let owner: Account
    var collection: Collection
    
    // Only in Detailed Asset
    let creator: Account?
    let listingDate: Date?
    let isPresale: Bool?
    let transferFeePaymentToken: Token?
    let transferFee: Double?
}
