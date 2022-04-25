//
//  Event.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

enum EventType: String, Codable {
    case created
    case successful
    case cancelled
    case bid_entered
    case bid_withdrawn
    case transfer
    case offer_entered
    case approve
}

enum AuctionType: String, Codable {
    case english
    case dutch
    case min_price
}

struct Event: Codable {
    /// A subfield containing a simplified version of the Asset on which this event happened
    var asset: Asset?
    /// A subfield containing a simplified version of the Asset Bundle on which this event happened
    let assetBundle: Bundle?
    /// Describes the event type
    let eventType: EventType?
    /// When the event was recorded
    let createdDate: Date
    /// The accounts associated with this event
    let fromAccount: Account?
    let toAccount: Account?
    /// A boolean value that is true if the sale event was a private sale
    let isPrivate: Bool?
    /// The payment asset used in this transaction, such as ETH, WETH or DAI
    let paymentToken: Token
    /// The amount of the item that was sold. Applicable for semi-fungible assets
    let quantity: String // (Int)
    /// The total price that the asset was bought for. This includes any royalties that might have been collected
    let totalPrice: String // (Double/Int)
    
    // Not Documented
    let transaction: Transaction?
    let winnerAccount: Account?
    let auctionType: AuctionType?
    let id: Int
    let bidAmount: Double?
    let contractAddress: String
    let duration: Int?
    let seller: Account?
    let startingPrice: Double?
    let endingPrice: Double?
    let ownerAccount: Account?
    let listingTime: Date?
}
