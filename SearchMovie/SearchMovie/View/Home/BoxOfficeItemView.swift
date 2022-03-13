//
//  MovieListItem.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/12.
//

import SwiftUI

struct BoxOfficeItemView: View {
    
    let movie: Movie
    let index: Int
    @State var isSheetOn: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Rectangle()
                .frame(width: 150, height: 255)
                .foregroundColor(.secondary)
                .overlay(
                    Image(systemName: "info.circle")
                        .offset(x: -53, y: 105)
                        .foregroundColor(.white)
                        .font(.title3)
                )
            
            VStack {
                Image(uiImage: movie.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:150)
                    .padding(.bottom, -10)
                    .overlay(
                        Text("\(index)")
                            .font(.system(size: 90))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0, x: 4, y: 4)
                            .frame(alignment: .bottomLeading)
                            .offset(x: 5 ,y: 20)
                        , alignment: .bottomLeading
                    )
                
            } //: VSTACK
        } //: ZSTACK
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            isSheetOn = true
        }
        .sheet(isPresented: $isSheetOn) {
            MovieDetailView(movie: movie)
        }
    }
}

struct MovieListItem_Previews: PreviewProvider {
    static var previews: some View {
        BoxOfficeItemView(movie: movieSample, index: 10)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
