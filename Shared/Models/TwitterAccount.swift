//
//  TwitterAccount.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

struct TwitterAccount: Codable {
    let id: Int64
    let name: String
    let screenName: String
    let followersCount: Int
    let friendsCount: Int
}
