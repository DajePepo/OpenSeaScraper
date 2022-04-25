//
//  DiscordRemoteRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class DiscordRemoteRepository {
    
    private let BASE_URL = "https://discord.com/api/v9/invites/"
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient = AlamofireHttpClient()) {
        self.httpClient = httpClient
    }
    
    func getDiscordServerInfo(serverId: String) async throws -> DiscordServer {
        
        let url = URL(string: BASE_URL + serverId)!
        let parameters: HttpParameters = ["with_counts": "true", "with_expiration": "true"]
        
        return try await withCheckedThrowingContinuation { continuation in
            httpClient.get(url, query: parameters) { response in
                
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        do {
                            guard let jsonData = response.data else {
                                return continuation.resume(with: .failure(BackendError.badData))
                            }
                            let server: DiscordServer = try DiscordServer.parse(from: jsonData)
                            continuation.resume(with: .success(server))
                        } catch {
                            print("Unable to retrieve Discord server info")
                            continuation.resume(with: .failure(BackendError.inherited(error, nil, nil)))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let data = response.data
                        let errorMessage = response.error.debugDescription
                        let errorCode = response.response?.statusCode ?? 0
                        print("Unable to retrieve Discord server info")
                        print("Error: \(errorMessage)")
                        continuation.resume(with: .failure(BackendError.inherited(error, data, errorCode)))
                    }
                }
            }
        }
    }
}
