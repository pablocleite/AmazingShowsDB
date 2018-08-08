//
//  TMDBImagesEntity.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

struct TMDBImagesEntity: Decodable {
    struct TMDBPosterEntity: Decodable {
        let filePath: String
    }
    
    let posters: [TMDBPosterEntity]
}
