//
//  MovieList.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import Foundation
import UIKit

struct MovieList: Codable {
    let total: Int
    let items: [MovieItem]
}

struct MovieItem: Codable {
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
    
    var movieDirector: String {
        director.replacingOccurrences(of: "|", with: "")
    }
    
//    var movieActor: [String] {
//        actor.split(separator: "|").map { String($0) }
//    }
    
    var movieImage: UIImage {
        guard let url = URL(string: image) else { return UIImage() }
        guard let data = try? Data(contentsOf: url) else { return UIImage() }
        guard let image = UIImage(data: data) else { return UIImage() }
        return image
    }
}

struct Movie: Identifiable {
    let id: UUID = UUID()
    var title: String = ""
    var link: String = ""
    var image: UIImage = UIImage()
    var subtitle: String = ""
    var director: String = ""
    var actors: String = ""
    var userRating: String = ""
    var plot: String = ""
    
    init(_ movieItem: MovieItem, _ moviePlot: String) {
        self.title = movieItem.movieTitle
        self.link = movieItem.link
        self.image = movieItem.movieImage
        self.subtitle = movieItem.subtitle
        self.director = movieItem.movieDirector
        self.actors = movieItem.actor
        self.userRating = movieItem.userRating
        self.plot = moviePlot
    }
    
    init() {
        
    }
}
