//
//  MovieList.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import Foundation

struct MovieList: Codable {
    let total: Int
    let items: [MovieItem]
}

struct MovieItem: Codable, Hashable {
    var title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
    
    var movieTitle: String {
        title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
    }
}
