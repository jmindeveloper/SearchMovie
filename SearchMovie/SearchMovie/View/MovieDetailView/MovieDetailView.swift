//
//  MovieDetailView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/13.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie
    var url: URL {
        URL(string: movie.link) ?? URL(string: "https://movie.naver.com/")!
    }
    let halfScreenHeight = UIScreen.main.bounds.height / 1.5
    @State private var isAnimated: Bool = false
    
    var body: some View {
        ZStack {
            Image(uiImage: movie.image)
                .resizable()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Text(movie.title)
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .padding(.top)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            Text(movie.subtitle)
                                .fontWeight(.medium)
                                .padding(.bottom)
                                .foregroundColor(.black)
                            
                            HeaderView(title: "감독", content: movie.director)
                            
                            HeaderView(title: "배우", content: movie.actors)
                            
                            HeaderView(title: "평점", content: movie.userRating)
                            
                            HeaderView(title: "줄거리", content: movie.plot)
                            
                            GroupBox {
                                Link(destination: url) {
                                    HStack {
                                        Text("더보기")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.right.square")
                                            .imageScale(.large)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 50)
                            
                        } //: VSTACK
                    } //: SCROLL.H
                    
                    Spacer()
                    
                } //: HSTACK
                .frame(height: halfScreenHeight)
                .background(
                    Color.white
                        .clipShape(CustonShape())
                        .shadow(radius: 4)
            ) //: BACKGROUND
            } //: VSTACK
            .offset(y: isAnimated ? 0 : 1000)
        } //: VSTACK
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimated = true
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: movieSample)
    }
}
