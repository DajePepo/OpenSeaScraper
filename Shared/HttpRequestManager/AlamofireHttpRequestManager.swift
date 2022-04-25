//
//  AlamofireHttpClient.swift
//  OpenSeaScraper
//
//  Created by Pietro Santececca on 13/01/22.
//  Copyright © 2022 Empatica Srl. All rights reserved.
//

import Alamofire
import Foundation

class AlamofireHttpClient: HttpClient {
    
    lazy var networkSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = HttpClientConfig.TIMEOUT_INTERVAL
        configuration.timeoutIntervalForResource = HttpClientConfig.TIMEOUT_INTERVAL
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func get(_ url: URL, query: HttpParameters? = nil, headers: HttpHeaders? = nil,
             done: @escaping (DataResponse<Any>) -> Void) {
        self.request(verb: .get, url: url, headers: headers, query: query, done: done)
    }
    
    func post(_ url: URL, query: HttpParameters? = nil, payload: HttpParameters? = nil, headers: HttpHeaders? = nil,
              done : @escaping (DataResponse<Any>) -> Void) {
        self.request(verb: .post, url: url, headers: headers, query: query, payload: payload, done: done)
    }
    
    func put(_ url: URL, payload: HttpParameters? = nil, headers: HttpHeaders? = nil,
             done: @escaping (DataResponse<Any>) -> Void) {
        self.request(verb: .put, url: url, headers: headers, payload: payload, done: done)
    }
    
    func put(_ url: URL, data: Data, headers: HttpHeaders? = nil, timeoutInterval: TimeInterval,
             done: @escaping (DataResponse<Data>) -> Void) {
        requestData(verb: .put, url: url, headers: headers, timeoutInterval: timeoutInterval, payload: data, done: done)
    }
    
    func patch(_ url: URL, payload: HttpParameters? = nil, headers: HttpHeaders? = nil,
               done: @escaping (DataResponse<Any>) -> Void) {
        self.request(verb: .patch, url: url, headers: headers, payload: payload, done: done)
    }
    
    func delete(_ url: URL, query: HttpParameters? = nil, headers: HttpHeaders? = nil,
                done: @escaping (DataResponse<Any>) -> Void) {
        self.request(verb: .delete, url: url, headers: headers, query: query, done: done)
    }
    
    fileprivate func request(
        verb: HTTPMethod,
        url: URL,
        headers: HttpHeaders? = nil,
        query: HttpParameters? = nil,
        payload: HttpParameters? = nil,
        done: @escaping (DataResponse<Any>) -> Void
    ) {
        let jsonPayload = payload.flatMap { try! JSONSerialization.data(withJSONObject: $0, options: []) }
        request(verb: verb, url: url, responseSerializer: DataRequest.jsonResponseSerializer(),
                headers: headers, query: query, payload: jsonPayload,
                done: done)
    }
    
    fileprivate func requestString(
        verb: HTTPMethod,
        url: URL,
        headers: HttpHeaders? = nil,
        query: HttpParameters? = nil,
        payload: String? = nil,
        done: @escaping (DataResponse<String>) -> Void
    ) {
        let stringPayload = payload?.data(using: .utf8)
        request(verb: verb, url: url, responseSerializer: DataRequest.stringResponseSerializer(),
                headers: headers, query: query, payload: stringPayload,
                done: done)
    }
    
    fileprivate func requestData(
        verb: HTTPMethod,
        url: URL,
        headers: HttpHeaders? = nil,
        query: HttpParameters? = nil,
        timeoutInterval: TimeInterval? = nil,
        payload: Data? = nil,
        done: @escaping (DataResponse<Data>) -> Void
    ) {
        request(verb: verb, url: url, responseSerializer: DataRequest.dataResponseSerializer(),
                headers: headers, query: query, timeoutInterval: timeoutInterval, payload: payload,
                done: done)
    }

    private func request<T>(
        verb: HTTPMethod,
        url: URL,
        responseSerializer: DataResponseSerializer<T>,
        headers: HttpHeaders? = nil,
        query: HttpParameters? = nil,
        timeoutInterval: TimeInterval? = nil,
        payload: Data? = nil,
        done: @escaping (DataResponse<T>) -> Void
    ) {
        
        var httpRequest = try! URLRequest(url: url, method: verb, headers: headers)
        httpRequest.timeoutInterval = timeoutInterval ?? HttpClientConfig.TIMEOUT_INTERVAL
        httpRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        if let query = query {
            httpRequest = try! URLEncoding(destination: .queryString).encode(httpRequest, with: query)
        }
        
        if let payload = payload {
            // Code taken from Alamofire's `JSONEncoding.default.encode(httpRequest, with: payload)` method.
            // We need to write it explicitly to use an arbitrary Data object as request body.
            // The caller is responsible to serialize it to JSON.
            httpRequest.httpBody = payload
            if httpRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        self.networkSessionManager.request(httpRequest)
            .validate()
            .response(responseSerializer: responseSerializer) { done($0) }
    }
}
