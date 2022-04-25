//
//  Bundle.swift
//  OpenSeaScraper
//
//  Created by Pietro on 20/04/22.
//

import Foundation

struct Bundle: Codable {
    let maker: Account
    let slug: String
    let assets: [Asset]
}
