//
//  OpenSeaLocalRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class OpenSeaLocalRepository {
    
    private var localAssets = [Asset]()
    private var localCollections = [Collection]()
    
    func getSaleEvents(
        from: Date? = nil,
        to: Date? = nil,
        tokenId: String? = nil,
        assetAddress: String? = nil,
        cursor: String? = nil
    ) -> (events: [Event], next: String?)? {
        
        return nil
    }
}

// MARK: - Assets

extension OpenSeaLocalRepository {
    
    func getAssetDetails(tokenId: String, contractAddress: String) -> Asset? {
        
        for asset in localAssets {
            if asset.tokenId == tokenId && asset.assetContract.address == contractAddress {
                return asset
            }
        }
        
        return nil
    }
    
    func storeAssetDetail(_ asset: Asset) {
        localAssets.append(asset)
    }
}

// MARK: - Collections

extension OpenSeaLocalRepository {
    
    func getCollectionDetails(slug: String) -> Collection? {
    
        for collection in localCollections {
            if collection.slug == slug { return collection }
        }
        
        return nil
    }
    
    func storeCollectinoDetail(_ collection: Collection) {
        localCollections.append(collection)
    }
}
