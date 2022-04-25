//
//  TwitterRemoteRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class TwitterRemoteRepository {
    
    private let TOKEN = "put here you token"
    private let BASE_URL = "https://api.twitter.com/1.1/"
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient = AlamofireHttpClient()) {
        self.httpClient = httpClient
    }
    
    func getTwitterAccountInfo(name: String) async throws -> TwitterAccount {
        
        let url = URL(string: BASE_URL + "users/show.json")!
        let parameters: HttpParameters = ["screen_name": name]
        let headers: HttpHeaders = ["authorization": "Bearer \(TOKEN)"]
        
        return try await withCheckedThrowingContinuation { continuation in
            httpClient.get(url, query: parameters, headers: headers) { response in
                
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        do {
                            guard let jsonData = response.data else {
                                return continuation.resume(with: .failure(BackendError.badData))
                            }
                            let account: TwitterAccount = try TwitterAccount.parse(from: jsonData)
                            continuation.resume(with: .success(account))
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
