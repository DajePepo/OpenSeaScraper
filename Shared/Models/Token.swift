//
//  Token.swift
//  OpenSeaScraper
//
//  Created by Pietro on 16/04/22.
//

import Foundation

struct Token: Codable {
    let symbol: String
    let address: String
    let name: String
    let decimals: Int
    let ethPrice: String? // (1.000000000000000)
    let usdPrice: String // (3037.869999999999891000)
}
