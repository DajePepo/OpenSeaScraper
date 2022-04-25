//
//  DiscordServer.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

struct DiscordServer: Codable {
    let code: String
    let approximateMemberCount: Int
    let approximatePresenceCount: Int
}
