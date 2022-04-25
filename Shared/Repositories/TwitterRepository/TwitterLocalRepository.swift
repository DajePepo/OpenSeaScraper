//
//  TwitterLocalRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class TwitterLocalRepository {
    
    private var localAccounts = [TwitterAccount]()
    
    func storeTwitterAccountInfo(_ account: TwitterAccount) {
        localAccounts.append(account)
    }
    
    func getTwitterAccountInfo(name: String) -> TwitterAccount? {
        
        for account in localAccounts {
            if account.screenName == name { return account }
        }
        
        return nil
    }
}
