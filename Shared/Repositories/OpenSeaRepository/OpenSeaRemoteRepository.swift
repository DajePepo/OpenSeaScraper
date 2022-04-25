//
//  OpenSeaRemoteRepository.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

class OpenSeaRemoteRepository {
    
    private let BASE_URL = "https://api.opensea.io/api/v1/"
    private let API_KEY = "put here your api key"
    
    private let httpClient: HttpClient
    
    private lazy var dateFormatter: DateFormatter = {
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dF
    }()
    
    init(httpClient: HttpClient = AlamofireHttpClient()) {
        self.httpClient = httpClient
    }
}

// MARK: - Asset Details

extension OpenSeaRemoteRepository {
    
    func getCollectionDetails(slug: String) async throws -> Collection {
        
        let url = URL(string: BASE_URL + "collection/" + slug)!
        let headers: HttpHeaders = ["Accept": "application/json",
                                    "X-API-KEY": API_KEY]
        
        return try await withCheckedThrowingContinuation { continuation in
            httpClient.get(url, headers: headers) { response in
                
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        do {
                            guard let jsonData = response.data else {
                                return continuation.resume(with: .failure(BackendError.badData))
                            }
                            let response: CollectionResponse = try CollectionResponse.parse(from: jsonData)
                            continuation.resume(with: .success(response.collection))
                        } catch {
                            print("Unable to retrieve Collection details")
                            continuation.resume(with: .failure(BackendError.inherited(error, nil, nil)))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let data = response.data
                        let errorMessage = response.error.debugDescription
                        let errorCode = response.response?.statusCode ?? 0
                        print("Unable to retrieve Collection details")
                        print("Error: \(errorMessage)")
                        continuation.resume(with: .failure(BackendError.inherited(error, data, errorCode)))
                    }
                }
            }
        }
    }
}

// MARK: - Asset Details

extension OpenSeaRemoteRepository {
    
    func getAssetDetails(tokenId: String, contractAddress: String) async throws -> Asset {
        
        let url = URL(string: BASE_URL + "asset/" + contractAddress + "/" + tokenId)!
        let parameters: HttpParameters = ["include_orders": true]
        let headers: HttpHeaders = ["Accept": "application/json",
                                    "X-API-KEY": API_KEY]
        
        return try await withCheckedThrowingContinuation { continuation in
            httpClient.get(url, query: parameters, headers: headers) { response in
                
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        do {
                            guard let jsonData = response.data else {
                                return continuation.resume(with: .failure(BackendError.badData))
                            }
                            let asset: Asset = try Asset.parse(from: jsonData)
                            continuation.resume(with: .success(asset))
                        } catch {
                            print("Unable to retrieve Asset details")
                            continuation.resume(with: .failure(BackendError.inherited(error, nil, nil)))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let data = response.data
                        let errorMessage = response.error.debugDescription
                        let errorCode = response.response?.statusCode ?? 0
                        print("Unable to retrieve Asset details")
                        print("Error: \(errorMessage)")
                        continuation.resume(with: .failure(BackendError.inherited(error, data, errorCode)))
                    }
                }
            }
        }
    }
}
 
// MARK: - Sale Events

extension OpenSeaRemoteRepository {
    
    func getSaleEvents(
        from: Date? = nil,
        to: Date? = nil,
        tokenId: String? = nil,
        assetAddress: String? = nil,
        cursor: String? = nil
    ) async throws -> (events: [Event], next: String?) {
        
        let endpoint = "events"
        let url = URL(string: BASE_URL + endpoint)!
        var parameters: HttpParameters = ["only_opensea": true,
                                          "event_type": "successful"]
        
        let headers: HttpHeaders = ["Accept": "application/json",
                                    "X-API-KEY": API_KEY]
        
        if let to = to { parameters["occurred_before"] = dateFormatter.string(from: to) }
        if let from = from { parameters["occurred_after"] = dateFormatter.string(from: from) }
        if let cursor = cursor { parameters["cursor"] = cursor }
        if let tokenId = tokenId { parameters["token_id"] = tokenId }
        if let assetAddress = assetAddress { parameters["asset_contract_address"] = assetAddress }
    
        return try await withCheckedThrowingContinuation { continuation in
            
            httpClient.get(url, query: parameters, headers: headers) { response in
                
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        do {
                            guard let jsonData = response.data else {
                                return continuation.resume(with: .failure(BackendError.badData))
                            }
                            let responseObj: EventsResponse = try EventsResponse.parse(from: jsonData)
                            let events = responseObj.assetEvents
                            continuation.resume(with: .success((events, responseObj.next)))
                        } catch {
                            print("Unable to retrieve Events")
                            continuation.resume(with: .failure(BackendError.inherited(error, nil, nil)))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let data = response.data
                        let errorMessage = response.error.debugDescription
                        let errorCode = response.response?.statusCode ?? 0
                        print("Unable to retrieve Events")
                        print("Error: \(errorMessage)")
                        continuation.resume(with: .failure(BackendError.inherited(error, data, errorCode)))
                    }
                }
            }
        }
    }
}
