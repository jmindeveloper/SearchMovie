//
//  BoxOfficeRanking.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import Foundation

//struct BoxOfficeRanking: Codable {
//    let boxOfficeResult: BoxOfficeResult
//}
//
//struct BoxOfficeResult: Codable {
//    let boxofficeType: String
//    let showRange: String
//    let boxOfficeList: [BoxOfficeList]
//
//    enum codingKey: String, CodingKey {
//        case boxofficeType, showRange
//        case boxOfficeList = "weeklyBoxOfficeList"
//    }
//}
//
//struct BoxOfficeList: Codable {
//    let rank: Int
//    let rankOldAndNew: String
//    let title: String
//
//    var isNew: Bool {
//        if rankOldAndNew == "OLD" {
//            return false
//        } else {
//            return true
//        }
//    }
//
//    enum codingKey: String, CodingKey {
//        case rank, rankOldAndNew
//        case title = "movieNm"
//    }
//}

// MARK: - UnitConvert
struct BoxOfficeRanking: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange, yearWeekTime: String
    let weeklyBoxOfficeList: [WeeklyBoxOfficeList]
}

// MARK: - WeeklyBoxOfficeList
struct WeeklyBoxOfficeList: Codable, Hashable {
    let rank: String
    let rankOldAndNew: RankOldAndNew
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case rank, rankOldAndNew
        case title = "movieNm"
    }
}

enum RankOldAndNew: String, Codable {
    case new = "NEW"
    case old = "OLD"
}
