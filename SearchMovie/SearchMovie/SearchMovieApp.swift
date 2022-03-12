//
//  SearchMovieApp.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import SwiftUI

@main

struct SearchMovieApp: App {
    
    @StateObject var boxOfficeViewModel = BoxOfficeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(boxOfficeViewModel: boxOfficeViewModel)
//                .environmentObject(BoxOfficeViewModel())
        }
    }
}
