
//
//  ShowViewModel.swift
//  AmazingShowsDB
//
//  Created by Pablo Leite on 07/08/2018.
//  Copyright © 2018 Pablo Cobucci Leite. All rights reserved.
//

import Foundation

struct ShowViewModel {
    let title: String
    let posterUrl: URL?
    
  init(show: Show, withPosterUrl posterUrl: URL? = nil) {
        title = show.title ?? ""
        self.posterUrl =  posterUrl
    }
}
