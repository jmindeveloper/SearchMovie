//
//  ContentView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import SwiftUI

struct ContentView: View {
    
//    @EnvironmentObject var boxOfficeViewModel: BoxOfficeViewModel
    @ObservedObject var boxOfficeViewModel: BoxOfficeViewModel
    
    var body: some View {
        List() {
            ForEach(boxOfficeViewModel.movies, id: \.self) { item in
                HStack {
                    Image(uiImage: boxOfficeViewModel.getPoster(item.image))
                    Text(item.movieTitle)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(boxOfficeViewModel: BoxOfficeViewModel())
    }
}
