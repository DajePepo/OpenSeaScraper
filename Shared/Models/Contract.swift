//
//  Contract.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

struct Contract: Codable {
    /// Address of the asset contract
    let address: String
    /// Name of the asset contract
    let name: String
    /// Symbol, such as CKITTY
    let symbol: String
    /// Image associated with the asset contract
    let imageUrl: String?
    /// Description of the asset contract
    let description: String?
    /// Link to the original website for this contract
    let externalLink: String?
    
    // Not Documented
    let assetContractType: String // TODO: Enum with following values: "semi-fungible", ...
    let createdDate: Date
    let nftVersion: String?
    let schemaName: String
    let defaultToFiat: Bool
    let devBuyerFeeBasisPoints: Int
    let devSellerFeeBasisPoints: Int
    let onlyProxiedTransfers: Bool
    let openseaBuyerFeeBasisPoints: Int
    let openseaSellerFeeBasisPoints: Int
    let buyerFeeBasisPoints: Int
    let sellerFeeBasisPoints: Int
}
