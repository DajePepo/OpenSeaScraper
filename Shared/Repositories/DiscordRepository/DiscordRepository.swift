//
//  DiscordRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class DiscordRepository {
    
    private let localRepository: DiscordLocalRepository
    private let remoteRepository: DiscordRemoteRepository
    
    init(localRepository: DiscordLocalRepository = DiscordLocalRepository(),
         remoteRepository: DiscordRemoteRepository = DiscordRemoteRepository()) {
        
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
    func getDiscordServerInfo(serverId: String) async throws -> DiscordServer {
        
        if let localServer = localRepository.getDiscordServerInfo(serverId: serverId) {
            return localServer
        }
        
        let remoteServer = try await remoteRepository.getDiscordServerInfo(serverId: serverId)
        localRepository.storeDiscordServerInfo(remoteServer)
        
        return remoteServer
    }
}
