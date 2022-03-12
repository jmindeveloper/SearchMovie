//
//  MovieViewModel.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import Foundation

class MovieViewModel {
    
    var movies: [MovieItem] = []
    
    init() {
    }
    
    func getMovies(_ query: String) {
        
        let aipKeys = ApiKey()
        
        let urlStr: String = "https://openapi.naver.com/v1/search/movie.json?query=\(query)"
        let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedStr) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(aipKeys.naverClientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(aipKeys.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            guard let movies = try? decoder.decode(MovieList.self, from: data) else { return }
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movies.items)
            }
        }.resume()
    }
}
