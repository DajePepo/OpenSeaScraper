//
//  Account.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

struct Account: Codable {
    /// The wallet address that uniquely identifies this account.
    let address: String
    /// An object containing username, a string for the the OpenSea username associated with the account. Will be null if the account owner has not yet set a username on OpenSea.
    let user: User?
    /// A string representing public configuration options on the user's account, including verified and moderator for OpenSea verified accounts and OpenSea community support staff.
    let config: String
}

extension Account {
    
    var isVerified: Bool {
        config == "verified"
    }
}
