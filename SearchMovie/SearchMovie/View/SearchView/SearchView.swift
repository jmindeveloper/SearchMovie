//
//  SearchView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/13.
//

//import UIKit
import SwiftUI

struct SearchView: View {
    
    @State private var searchMovieName: String = ""
    @ObservedObject var movieViewModel: MovieViewModel
    let column: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        
        VStack {
            
            SearchBar(searchMovieName: $searchMovieName, movieViewModel: movieViewModel)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: column) {
                    ForEach(movieViewModel.searchResultMovieList) { movie in
                        MovieItemView(movie: movie, index: nil)
                            .frame(width: UIScreen.main.bounds.width / 2 - 10)
                    }
                }
            } //: SCROLL.V
        } //: VSTACK
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
