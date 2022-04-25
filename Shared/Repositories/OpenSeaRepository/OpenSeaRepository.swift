//
//  OpenSeaRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 10/04/22.
//

import Foundation

class OpenSeaRepository {
    
    private let localRepository: OpenSeaLocalRepository
    private let remoteRepository: OpenSeaRemoteRepository
    
    init(localRepository: OpenSeaLocalRepository = OpenSeaLocalRepository(),
         remoteRepository: OpenSeaRemoteRepository = OpenSeaRemoteRepository()) {
        
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
    func getCollectionDetails(slug: String) async throws -> Collection {
        
        if let localCollection = localRepository.getCollectionDetails(slug: slug) {
            return localCollection
        }
        
        let remoteCollection = try await remoteRepository.getCollectionDetails(slug: slug)
        localRepository.storeCollectinoDetail(remoteCollection)
        
        return remoteCollection
    }

    func getAssetDetails(tokenId: String, contractAddress: String) async throws -> Asset {
        
        if let localAsset = localRepository.getAssetDetails(tokenId: tokenId, contractAddress: contractAddress) {
            return localAsset
        }
        
        let remoteAsset = try await remoteRepository.getAssetDetails(tokenId: tokenId, contractAddress: contractAddress)
        localRepository.storeAssetDetail(remoteAsset)
        
        return remoteAsset
    }
    
    func getSaleEvents(
        from: Date? = nil,
        to: Date? = nil,
        tokenId: String? = nil,
        assetAddress: String? = nil,
        cursor: String? = nil
    ) async throws -> (events: [Event], next: String?) {
        
        try await remoteRepository.getSaleEvents(from: from, to: to, tokenId: tokenId, assetAddress: assetAddress, cursor: cursor)
    }
}
