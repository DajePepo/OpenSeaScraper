//
//  CsvManager.swift
//  OpenSeaScraper
//
//  Created by Pietro on 17/04/22.
//

import Foundation
import CodableCSV

class CsvManager {
    
    func createCsv(data: [DataRow]) throws {
        
        guard data.count > 0 else {
            print("Impossible to create CSV: No rows")
            throw NSError()
        }
        
        let url = URL.documents.appendingPathComponent("NftData_5000.csv")
        let headers = ["Item ID",
                       "Price Percentage Variation",
                       "Initial Price",
                       "Final Price",
                       "Token",
                       "Sale Date",
                       "Item Creation Date",
                       "Item Creation Date (secs)",
                       "Is Collection Featured",
                       "Collection Floor Price",
                       "Collection Avarage Price",
                       "Collection Items Count",
                       "Collection Owners Count",
                       "Seller Fee",
                       "Is Seller Verified",
                       "Is Creator Verified",
                       "Discord Members Count",
                       "Twitter Followers Count"]
        
        let writer = try CSVWriter(fileURL: url) {
            $0.headers = headers
            $0.encoding = .utf8
        }
        
        for row in data {
            try writer.write(field: "\(row.itemId)")
            try writer.write(field: "\(row.pricePercentageVariation)")
            try writer.write(field: "\(row.initialPrice)")
            try writer.write(field: "\(row.finalPrice)")
            try writer.write(field: "\(row.token)")
            try writer.write(field: "\(row.saleDate)")
            try writer.write(field: "\(row.itemCreationDate)")
            try writer.write(field: "\(row.itemCreationDateInSecs)")
            try writer.write(field: "\(row.isCollectionFeatured ? 1 : 0)")
            try writer.write(field: "\(row.collectionFloorPrice)")
            try writer.write(field: "\(row.collectionAvaragePrice)")
            try writer.write(field: "\(row.collectionItemsCount)")
            try writer.write(field: "\(row.collectionOwnersCount)")
            try writer.write(field: "\(row.sellerFee)")
            try writer.write(field: "\(row.isSellerVerified ? 1 : 0)")
            try writer.write(field: "\(row.isCreatorVerified ? 1 : 0)")
            try writer.write(field: "\(row.discordMembersCount)")
            try writer.write(field: "\(row.twitterFollowersCount)")
            try writer.endRow()
        }
        
        try writer.endEncoding()
    }
}


extension URL {
    
    static var documents: URL {
        try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
