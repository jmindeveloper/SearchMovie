//
//  MovieDetailView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/13.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie
    var url: URL {
        URL(string: movie.link)!
    }
    
    var body: some View {
        VStack {
            Link("네이버 영화에서 보기", destination: url)
            
            Text(movie.plot)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: movieSample)
    }
}
