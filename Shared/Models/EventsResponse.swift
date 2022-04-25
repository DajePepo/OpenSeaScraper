//
//  EventsResponse.swift
//  OpenSeaScraper
//
//  Created by Pietro on 24/04/22.
//

import Foundation

struct EventsResponse: Codable {
    let next: String?
    let previous: String?
    let assetEvents: [Event]
}
