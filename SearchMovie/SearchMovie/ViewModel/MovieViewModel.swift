//
//  BoxOfficeViewModel.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

/*
 영화정보를 받아오는데 너무많은 시간이 걸림
 네트워킹작업이 많아서 그런지 아님 내가 잘못한건지...
 
 --> global큐로 동시작업으로 해결
 
    메인큐는 직렬(하나의 쓰레드), 글로벌큐는 동시(여러개 쓰레드)
    네트워킹 작업을 여러개의 쓰레드에서 동시에 하니 당연히 속도가 빨라짐
    
    네트워킹 작업을 메인큐에서 직렬로 처리하지 않고 글로벌큐에서 동시처리하니 네트워킹작업중 앱이 멈추는 현상이 안일어남 --> 이건 맞는지 잘 모르겠음
 
 */


/*
 네트워킹 순서
 
 1. getBoxOffice 를 통해서 주간박스오피스 정보를 받아온다
 2. 주간 박스오피스 정보를 받아오면 map으로 영화제목만 뽑아낸다
 3. 뽑아낸 영화제목을 getMovieDetail의 매개변수로 넣어서 각각의 영화정보를 받아온다
 4. 크롤링작업을 통하여 영화의 줄거리를 받아온다
 5. movies: [Movie] 배열에 Movie(영화정보, 줄거리)
 
*/

import Foundation
import SwiftUI
import SwiftSoup // 크롤링을 위한 라이브러리

// preview를 위한 더미데이터
let movieSample: Movie = Movie(MovieItem(title: "<b>더 배트맨</b>", link: "https://movie.naver.com/movie/bi/mi/basic.nhn?code=154282", image: "https://ssl.pstatic.net/imgmovie/mdi/mit110/1542/154282_P04_170044.jpg", subtitle: "The Batman", pubDate: "2022", director: "맷 리브스|", actor: "로버트 패틴슨|배우1|배우2|배우3", userRating: "7.15"), "<장르 서브 장르>는 누사 텐가라 티무르 박물관이 주최한 영화와 사진 프로젝트에 포함되었던 실험 비디오 작품이다. 신비로운 분위기가 지배하는 흑백 필름인 이 영화는 세 개의 삽화로 나누어져 있다. 야심한 밤에 지프에 무언가를 싣고 온 청년들, 따가운 볕이 내리쬐는 한낮에 나무 아래서 축구를 하는 아이들, 그리고 강물 위로 떠가는 종이배의 항해 에피소드가 이어진다. 인도네시아의 실험영화 작가 요셉 앙기 노엔은 분리된 삽화들 사이의 연관성을 명시하지 않은 채 사실적인 밤의 이미지와 백일몽과 같은 낮의 이미지들을 대비시킨다. 거대한 종이배가 화면을 가로질러가는 아름다운 라스트 신이 인상적이다. (장병원)[제15회 전주국제영화제]")

class MovieViewModel: ObservableObject {
    
    @Published var boxOfficeType: String = ""
    @Published var boxOfficeDateRange: String = ""
    @Published var boxOfficeMovieList: [Movie] = Array(repeating: Movie(), count: 10)
    @Published var searchResultMovieList: [Movie] = []
    
    init() {
        print("init")
        getBoxOfficeMovieList("20220307")
    }
    
    // boxoffice 영화리스트 가져오기
    func getBoxOfficeMovieList(_ date: String) {
        getBoxOffice(date) { boxOffice in
            // 박스오프스 정보에서 영화제목만 빼오기
            let movieTitles = boxOffice.boxOfficeResult.weeklyBoxOfficeList.map { $0.title }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.boxOfficeType = boxOffice.boxOfficeResult.boxofficeType
                self.boxOfficeDateRange = boxOffice.boxOfficeResult.showRange
                
            }
            // 빼온 영화제목으로 영화 디테일정보 받아오기
            for (index, title) in movieTitles.enumerated() {
                self.getMovieDetail(title) { aMovie in
                    DispatchQueue.global().async { [weak self] in
                        guard let self = self else { return }
                        // 줄거리랑 영화정보 받아오는작업은 글로벌큐에서 비동기적으로 동시 수행
                        let plot = self.getMoviePlot(aMovie[0].link)
                        let movie = Movie(aMovie[0], plot)
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            // 배열에 저장은 ui관련이므로 메인큐에서 수행
                            /*
                             ?: 들어간 순서대로 append 되지 않음 -> dispatchqueue때문?
                             결국 영화배열을 미리 만들어논다음 들어간 순서대로 교체해줬음( list[index] = movie )
                             */
                            self.boxOfficeMovieList[index] = movie
                        }
                    }
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
            
//            DispatchQueue.main.async {
                completion(boxOfficeRanking)
//            }
        }.resume()
    }
    
    // 영화정보 가져오기(네이버영화검색api)
    func getMovieDetail(_ query: String, _ getCount: Int = 10, _ completion: @escaping ([MovieItem]) -> Void) {
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
            
//            DispatchQueue.main.async {
                completion(movieList.items)
//            }
        }.resume()
    }
    
    // 영화 줄거리 가져오기(크롤링)
    func getMoviePlot(_ url: String) -> String {
        guard let url = URL(string: url) else { return "" }
        
        guard let html = try? String(contentsOf: url, encoding: .utf8) else { return "" }
        guard let doc: Document = try? SwiftSoup.parse(html) else { return "" }
        
        guard let plot: Elements = try? doc.select("div.story_area p.con_tx") else { return "" }
        
        guard let moviePlot = try? plot.text() else { return "" }
        return moviePlot
    }
    
    func getSearchMovie(_ searchMovieName: String) {
        searchResultMovieList = []
        print("\(searchMovieName) 검색시작")
        getMovieDetail(searchMovieName, 100) { movie in
            
            DispatchQueue.global().async {
                
                for movie in movie {
                    DispatchQueue.global().async {
                        let plot = self.getMoviePlot(movie.link)
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.searchResultMovieList.append(Movie(movie, plot))
                    }
                    }
                }
            }
            
//            DispatchQueue.main.async {
//                self.searchResultMovieList = movie.map({ movieItem in
//                    var plot = ""
//                    DispatchQueue.global().async {
//                        plot = self.getMoviePlot(movieItem.link)
//                    }
//                    return Movie(movieItem, plot)
//                })
//            }
            
        }
    }
}
