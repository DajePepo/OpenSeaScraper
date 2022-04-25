//
//  HttpClient.swift
//  OpenSeaScraper
//
//  Created by Pietro Santececca on 04/08/2020.
//  Copyright © 2020 Empatica Srl. All rights reserved.
//

import Alamofire
import Foundation

typealias HttpHeaders = [String: String]
typealias HttpCompletion = (Swift.Result<String, BackendError>) -> Void
typealias HttpParameters = [String: Any]

enum BackendError: Error {
    case generic
    case inherited(Error, Data?, Int?)
    case connection
    case timedOut
    case badData
    case emptyData
    case backendCodedError(errorCode: Int)
}

enum HttpClientError : Swift.Error {
    case malformedUrl
    case invalidUrlComponents
}

struct HttpClientConfig {
    static let TIMEOUT_INTERVAL: TimeInterval = 30
}

protocol HttpClient {

    func get(_ url: URL, query: HttpParameters?, headers: HttpHeaders?,
             done: @escaping (DataResponse<Any>) -> Void)

    func post(_ url: URL, query: HttpParameters?, payload: HttpParameters?, headers: HttpHeaders?,
              done : @escaping (DataResponse<Any>) -> Void)

    func put(_ url: URL, payload: HttpParameters?, headers: HttpHeaders?,
             done: @escaping (DataResponse<Any>) -> Void)

    func put(_ url: URL, data: Data, headers: HttpHeaders?, timeoutInterval: TimeInterval,
             done: @escaping (DataResponse<Data>) -> Void)

    func patch(_ url: URL, payload: HttpParameters?, headers: HttpHeaders?,
               done: @escaping (DataResponse<Any>) -> Void)

    func delete(_ url: URL, query: HttpParameters?, headers: HttpHeaders?,
                done: @escaping (DataResponse<Any>) -> Void)
}

extension HttpClient {

    func get(_ url: URL, headers: HTTPHeaders, done: @escaping (DataResponse<Any>) -> Void) {
        self.get(url, query: nil, headers: headers, done: done)
    }
    
    func get(_ url: URL, query: HttpParameters? = nil, done: @escaping (DataResponse<Any>) -> Void) {
        self.get(url, query: query, headers: nil, done: done)
    }

    func post(_ url: URL, done : @escaping (DataResponse<Any>) -> Void) {
        self.post(url, query: nil, payload: nil, headers: nil, done: done)
    }

    func put(_ url: URL, done: @escaping (DataResponse<Any>) -> Void) {
        self.put(url, payload: nil, headers: nil, done: done)
    }

    func put(_ url: URL, data: Data, headers: HttpHeaders?, timeoutInterval: TimeInterval, done: @escaping (DataResponse<Data>) -> Void) {
        self.put(url, data: data, headers: headers, timeoutInterval: HttpClientConfig.TIMEOUT_INTERVAL, done: done)
    }

    func patch(_ url: URL, done: @escaping (DataResponse<Any>) -> Void) {
        self.patch(url, payload: nil, headers: nil, done: done)
    }

    func delete(_ url: URL, done: @escaping (DataResponse<Any>) -> Void) {
        self.delete(url, query: nil, headers: nil, done: done)
    }
}
