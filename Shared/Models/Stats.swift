//
//  Stats.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

struct Stats: Codable {
    let averagePrice: Double
    let count: Int
    let floorPrice: Double?
    let marketCap: Double
    let numOwners: Int
    let numReports: Int
    let oneDayAveragePrice: Double
    let oneDayChange: Double
    let oneDaySales: Int
    let oneDayVolume: Double
    let sevenDayAveragePrice: Double
    let sevenDayChange: Double
    let sevenDaySales: Int
    let sevenDayVolume: Double
    let thirtyDayAveragePrice: Double
    let thirtyDayChange: Double
    let thirtyDaySales: Int
    let thirtyDayVolume: Double
    let totalSales: Int
    let totalSupply: Int
    let totalVolume: Double
}
