//
//  HomeView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var movieViewModel = MovieViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Group {
                        Text("Boxoffice")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Text(movieViewModel.boxOfficeDateRange)
                            .italic()
                            .padding(.horizontal)
                            .padding(.top, 3)
                            .padding(.bottom)
                    } //: BOXOFFICE TITLE
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(movieViewModel.boxOfficeMovieList.indices, id: \.self) { index in
                                MovieItemView(movie: movieViewModel.boxOfficeMovieList[index], index: index + 1)
                            } //: LOOP
                        } //: HSTACK
                        .padding(.horizontal)
                    } //: SCROLL.H
                } //: VSTACK
            } //: SCROLL.V
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        } //: NAVIGATION
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
