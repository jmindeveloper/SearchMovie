//
//  BoxOfficeViewModel.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import Foundation
import SwiftUI

class BoxOfficeViewModel: ObservableObject {
    
    @Published var boxOfficeType: String = ""
    @Published var boxOfficeDateRange: String = ""
    @Published var boxOfficeList: [WeeklyBoxOfficeList] = []
    @Published var movies: [MovieItem] = [MovieItem](repeating: MovieItem(title: "", link: "", image: "", subtitle: "", pubDate: "", director: "", actor: "", userRating: ""), count: 10)
    
    init() {
        getboxOffice("20220306")
    }
    
    // boxOffice 정보 가져오기
    func getboxOffice(_ date: String) {
        let apiKey = ApiKey()
        
        guard let url = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=\(apiKey.koficApiKey)&targetDt=\(date)&weekGb=0") else { return }
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            guard let boxOfficeRanking = try? decoder.decode(BoxOfficeRanking.self, from: data) else { return }
            guard let self = self else { return }
            
            
            DispatchQueue.main.async {
                self.boxOfficeType = boxOfficeRanking.boxOfficeResult.boxofficeType
                self.boxOfficeList = boxOfficeRanking.boxOfficeResult.weeklyBoxOfficeList
                self.boxOfficeDateRange = boxOfficeRanking.boxOfficeResult.showRange
                self.getMovieDetail(self.boxOfficeList)
            }
        }.resume()
    }
    
    //
    func getMovieDetail(_ movies: [WeeklyBoxOfficeList]) {
        for movie in movies {
            getMovies(movie.title, getCount: "1")
        }
    }
    
    // 영화정보 가져오기
    func getMovies(_ query: String, getCount: String = "10") {
        
        let aipKeys = ApiKey()
        
        let urlStr: String = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=\(getCount)"
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
                self.moviesAppend(movies.items[0].movieTitle, movies)
            }
        }.resume()
    }
    
    func moviesAppend(_ title: String, _ movie: MovieList) {
        let index = boxOfficeList.firstIndex { $0.title == title }
        guard let movieIndex = index else { return }
        self.movies[movieIndex] = movie.items[0]
    }
    
    func getPoster(_ urlStr: String) -> UIImage {
        guard let url = URL(string: urlStr) else { return UIImage() }
        guard let data = try? Data(contentsOf: url) else { return UIImage() }
        guard let image = UIImage(data: data) else { return UIImage() }
        return image
    }
    
}
