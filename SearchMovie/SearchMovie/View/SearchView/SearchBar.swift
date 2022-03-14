//
//  SearchBar.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/14.
//

import SwiftUI

struct SearchBar: View {
    
    @FocusState private var isEndEditing: Bool
    @Binding var searchMovieName: String
    @ObservedObject var movieViewModel: MovieViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(uiColor: UIColor.systemGray6))

                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchMovieName)
                        .focused($isEndEditing)
                } //: HSTACK
                .padding(.leading)
            } //: ZSTACK
            .frame(height: 40)
            .cornerRadius(8)
            .padding([.leading, .vertical])

            Button(action: {
                isEndEditing = false
                movieViewModel.getSearchMovie(searchMovieName)
            }, label: {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
            }) //: BUTTON
                .padding(.trailing)
        } //: HSTACK
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchMovieName: .constant(""), movieViewModel: MovieViewModel())
    }
}
