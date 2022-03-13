//
//  BoxOfficeViewModel.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import Foundation
import SwiftUI

let movieSample: Movie = Movie(MovieItem(title: "<b>더 배트맨</b>", link: "https://movie.naver.com/movie/bi/mi/basic.nhn?code=154282", image: "https://ssl.pstatic.net/imgmovie/mdi/mit110/1542/154282_P04_170044.jpg", subtitle: "The Batman", pubDate: "2022", director: "맷 리브스|", actor: "로버트 패틴슨|배우1|배우2|배우3", userRating: "7.15"))

class BoxOfficeViewModel: ObservableObject {
    
    @Published var boxOfficeType: String = ""
    @Published var boxOfficeDateRange: String = ""
    @Published var boxOfficeMovieList: [Movie] = Array(repeating: Movie(), count: 10)
    
    
    init() {
        print("init")
        getBoxOfficeMovieList("20220306")
    }
    
    // boxoffice 영화리스트 가져오기
    func getBoxOfficeMovieList(_ date: String) {
        getBoxOffice(date) {
            print("get boxoffice success")
            let movieTitles = $0.boxOfficeResult.weeklyBoxOfficeList.map { $0.title }
            self.boxOfficeType = $0.boxOfficeResult.boxofficeType
            self.boxOfficeDateRange = $0.boxOfficeResult.showRange
            for (index, title) in movieTitles.enumerated() {
                self.getMovieDetail(title) {
                    print("get movieDetail success")
                    let movie = Movie($0)
                    self.boxOfficeMovieList[index] = movie
                }
            }
        }
    }
    
    // boxoffice 가져오기(한국영화진흥원)
    func getBoxOffice(_ date: String, _ completion: @escaping (BoxOfficeRanking) -> Void) {
        let apiKey = ApiKey()
        
        guard let url = URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=\(apiKey.koficApiKey)&targetDt=\(date)&weekGb=0") else { return }

        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            guard let boxOfficeRanking = try? decoder.decode(BoxOfficeRanking.self, from: data) else { return }
            
            DispatchQueue.main.async {
                completion(boxOfficeRanking)
            }
        }.resume()
    }
    
    // 영화정보 가져오기(네이버영화검색api)
    func getMovieDetail(_ query: String, _ getCount: Int = 10, _ completion: @escaping (MovieItem) -> Void) {
        let apiKey = ApiKey()
        let getCount = String(getCount)
        let urlStr: String = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=\(getCount)"
        let encodeUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodeUrl) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey.naverClientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(apiKey.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            guard let movieList = try? decoder.decode(MovieList.self, from: data) else { return }
            
            DispatchQueue.main.async {
                completion(movieList.items[0])
            }
        }.resume()
    }
    
}
