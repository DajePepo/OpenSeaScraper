//
//  Codable.swift
//  OpenSeaScraper
//
//  Created by Pietro on 15/04/22.
//

import Foundation

extension Decodable {

    /// Read a Data object contained encoded JSON content
    /// and convert to a struct or class implementing the Decodable protocol.
    public static func parse<T: Decodable>(from jsonData: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = DateFormatter.preciseDateFormatter.date(from: dateString) {
                return date
            }
            
            if let date = DateFormatter.dateFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
        return try decoder.decode(T.self, from: jsonData)
    }
}

extension Encodable {

    /// Serialize a Encodable protocol instance to a JSON map.
    public func toJSON() throws -> [String: Any]? {
        return try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as? [String: Any]
    }
}
