//
//  TwitterRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class TwitterRepository {
    
    private let localRepository: TwitterLocalRepository
    private let remoteRepository: TwitterRemoteRepository
    
    init(localRepository: TwitterLocalRepository = TwitterLocalRepository(),
         remoteRepository: TwitterRemoteRepository = TwitterRemoteRepository()) {
        
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
    func getTwitterAccountInfo(name: String) async throws -> TwitterAccount {
        
        if let localAccount = localRepository.getTwitterAccountInfo(name: name) {
            return localAccount
        }
        
        let remoteAccount = try await remoteRepository.getTwitterAccountInfo(name: name)
        localRepository.storeTwitterAccountInfo(remoteAccount)
        
        return remoteAccount
    }
}
