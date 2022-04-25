//
//  ContentViewModel.swift
//  OpenSeaScraper
//
//  Created by Pietro on 16/04/22.
//

import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {

    private let STARTING_DATE = Date(year: 2022, month: 3, day: 20)
    private let ENDING_DATE = Date(year: 2022, month: 4, day: 20)
    
    private let openSeaRepository = OpenSeaRepository()
    private let twitterRepository = TwitterRepository()
    private let discordRepository = DiscordRepository()
    private let csvManager = CsvManager()
    
    
    @Published var sales: [DataRow] = []
    
    func fetchSaleEvents() async {
        
        do {
            
            // Fetch events
            print("Start fetching sale events")
            var cursor: String?
            var events = [Event]()
            
            repeat {
                let (newEvents, newCursor) = try await openSeaRepository.getSaleEvents(from: STARTING_DATE,
                                                                                       to: ENDING_DATE,
                                                                                       cursor: cursor)
                events.append(contentsOf: newEvents)
                cursor = newCursor
                print("Fetched \(events.count) sale events")
            } while events.count < 5000 // cursor == nil
            
            // Filter out event about Asset with only one sale
            // Indeed we are interested in calculating the increment of price between one sale and the next one
            print("Filtered out events with only one sale")
            let eventsWithResoldAssets = events.filter { $0.asset != nil && $0.asset!.numSales > 1 }
        
            // Get asset details
            print("For each sale event getting the asset detail info")            
            let assets = eventsWithResoldAssets.compactMap { $0.asset }
            var eventsWithMultipleSales = [Event]()
            for asset in assets {

                try? await Task.sleep(nanoseconds: 1 * 100_000_000) // 100 milliseconds
                
                var asset = try await openSeaRepository.getAssetDetails(tokenId: asset.tokenId,
                                                                        contractAddress: asset.assetContract.address)
                
                let collection = try await openSeaRepository.getCollectionDetails(slug: asset.collection.slug)

                let (newEvents, _) = try await openSeaRepository.getSaleEvents(tokenId: asset.tokenId,
                                                                               assetAddress: asset.assetContract.address)

                let lastTwoEvents = newEvents.sorted(by: { $0.createdDate > $1.createdDate }).prefix(2)
                asset.collection = collection
                
                for var event in lastTwoEvents {
                    guard !eventsWithMultipleSales.contains(where: { $0.id == event.id }) else { continue }
                    event.asset = asset
                    eventsWithMultipleSales.append(event)
                }
                
                print("New event retrieved: \(eventsWithMultipleSales.count)")
            }
            
            // Group events by asset
            print("Group sale events by token and address")
            let eventsGroupedByAssets = Dictionary(grouping: eventsWithMultipleSales) { getAssetId(of: $0) }
            
            // Create data row
            print("Creating for each sale events the corresponding row data")
            var dataRowList = [DataRow]()
            for (_, events) in eventsGroupedByAssets {
                
                let sortedEvents = events.sorted { $0.createdDate < $1.createdDate }
                
                var previousSalePrice: Double = 0
                for event in sortedEvents {
                    
                    try? await Task.sleep(nanoseconds: 1 * 100_000_000) // 100 milliseconds
                    
                    let itemId = getAssetId(of: event)
                    let newSalePrice = getTotalPriceInDollar(event)
                    let collectionFloorPrice = getCollectionFloorPriceInDollar(event)
                    let collectionAvaragePrice = getCollectionAvaragePriceInDollar(event)
                    
                    var twitterFollowersCount = 0
                    if let twitterName = event.asset?.collection.twitterUsername {
                        do {
                            twitterFollowersCount = try await twitterRepository
                                .getTwitterAccountInfo(name: twitterName)
                                .followersCount
                            print("Followers count is \(twitterFollowersCount)")
                        } catch {
                            print("Failed to get twitter account info \(twitterName)")
                        }
                    } else {
                        print("Collection has no twitter account")
                    }
                    
                    var discordMembersCount = 0
                    if let serverId = event.asset?.collection.discordUrl?.split(separator: "/").last {
                        do {
                            discordMembersCount = try await discordRepository
                                .getDiscordServerInfo(serverId: String(serverId))
                                .approximateMemberCount
                            print("Discord members count is \(discordMembersCount)")
                        } catch {
                            print("Failed to get discord info \(serverId)")
                        }
                    } else {
                        print("Collection has no discord server")
                    }
                    
                    if previousSalePrice > 0 {
                        let pricePercentageVariation = (newSalePrice - previousSalePrice) / previousSalePrice
                        dataRowList.append(
                            DataRow(
                                itemId: itemId,
                                pricePercentageVariation: pricePercentageVariation,
                                initialPrice: previousSalePrice,
                                finalPrice: newSalePrice,
                                token: event.paymentToken.name,
                                saleDate: event.createdDate,
                                itemCreationDate: event.asset!.assetContract.createdDate,
                                itemCreationDateInSecs: event.asset!.assetContract.createdDate.timeIntervalSince1970,
                                isCollectionFeatured: event.asset!.collection.featured,
                                collectionFloorPrice: collectionFloorPrice,
                                collectionAvaragePrice: collectionAvaragePrice,
                                collectionItemsCount: event.asset!.collection.stats!.count,
                                collectionOwnersCount: event.asset!.collection.stats!.numOwners,
                                sellerFee: event.asset!.assetContract.sellerFeeBasisPoints,
                                isSellerVerified: event.seller?.isVerified == true,
                                isCreatorVerified: event.asset!.creator?.isVerified == true,
                                discordMembersCount: discordMembersCount,
                                twitterFollowersCount: twitterFollowersCount
                            )
                        )
                    }
                    
                    previousSalePrice = newSalePrice
                }
            }
            
            self.sales = dataRowList
            
            print("So the final number of collected sales is: \(sales.count)")
            
        } catch {
            print("fetchSaleEvents - Error: \(error)")
        }
    }

    private func getAssetId(of event: Event) -> String {
        event.asset!.tokenId + event.asset!.assetContract.address
    }
    
    private func getTotalPriceInDollar(_ event: Event) -> Double {
        
        let decimals = event.paymentToken.decimals
        let dollarChangeRatio = Double(event.paymentToken.usdPrice)!
        var price = Double(event.totalPrice)!
        
        for _ in 1...decimals { price = price / 10 }
        return price * dollarChangeRatio
    }
    
    private func getCollectionFloorPriceInDollar(_ event: Event) -> Double {
        let price = event.asset!.collection.stats!.floorPrice ?? 0
        let dollarChangeRatio =  Double(event.paymentToken.usdPrice)!
        return price * dollarChangeRatio
    }
    
    private func getCollectionAvaragePriceInDollar(_ event: Event) -> Double {
        let price = event.asset!.collection.stats!.averagePrice
        let dollarChangeRatio =  Double(event.paymentToken.usdPrice)!
        return price * dollarChangeRatio
    }
    
    func writeSalesOnCvs() {
        
        guard sales.count > 0 else {
            return print("Nothing to write")
        }
        
        do {
            try csvManager.createCsv(data: sales)
        } catch {
            print("Failed to create csv, error: \(error.localizedDescription)")
        }
    }
    
    func clearSalesEvents() {
        sales = []
    }
}
