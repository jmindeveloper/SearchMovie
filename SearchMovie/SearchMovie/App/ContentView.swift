//
//  ContentView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var movieViewModel = MovieViewModel()
    
    var body: some View {
        TabView {
            HomeView(movieViewModel: movieViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SearchView(movieViewModel: movieViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

