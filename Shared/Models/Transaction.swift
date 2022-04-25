//
//  Transaction.swift
//  OpenSeaScraper
//
//  Created by Pietro on 16/04/22.
//

import Foundation

struct Transaction: Codable {
    let id: Int
    let blockHash: String
    let blockNumber: String
    let fromAccount: Account
    let toAccount: Account
    let timestamp: Date
    let transactionHash : String
    let transactionIndex: String
}
