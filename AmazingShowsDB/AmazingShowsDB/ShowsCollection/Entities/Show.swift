//
//  Show.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

//

/*
 {
 "title": "Game of Thrones",
 "year": 2011,
 "ids": {
 "trakt": 1390,
 "slug": "game-of-thrones",
 "tvdb": 121361,
 "imdb": "tt0944947",
 "tmdb": 1399,
 "tvrage": 24493
 }
 },
 */
struct Show: Decodable {
    
    struct ServiceIds: Decodable {
        let trakt: Int?
        let slug: String?
        let tvdb: Int?
        let imdb: String?
        let tmdb: Int?
        let tvrage: Int?
    }
    
    let title: String?
    let year: Int?
    let serviceIds: ServiceIds?
    
    enum CodingKeys: String, CodingKey {
        case title
        case year
        case serviceIds = "ids"
    }
    
    enum AdditionalCodingKeys: String, CodingKey {
        case watchers
        case show
    }
    
    enum IdsCodingKeys: String, CodingKey {
        case trakt
        case slug
        case tvdb
        case imdb
        case tvrage
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AdditionalCodingKeys.self)
        let showContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .show)
        title = try showContainer.decodeIfPresent(String.self, forKey: .title)
        year = try showContainer.decodeIfPresent(Int.self, forKey: .year)
        serviceIds = try showContainer.decodeIfPresent(ServiceIds.self, forKey: .serviceIds)
    }

}
