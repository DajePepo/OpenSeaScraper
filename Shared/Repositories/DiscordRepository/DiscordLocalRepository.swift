//
//  DiscordLocalRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class DiscordLocalRepository {
    
    private var localServers = [DiscordServer]()
    
    func storeDiscordServerInfo(_ server: DiscordServer) {
        localServers.append(server)
    }
    
    func getDiscordServerInfo(serverId: String) -> DiscordServer? {
        
        for server in localServers {
            if server.code == serverId { return server }
        }
        
        return nil
    }
}
