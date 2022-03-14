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
    @FocusState private var isEndEditing: Bool
    
    var body: some View {
        
        VStack {
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
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                }) //: BUTTON
                    .padding(.trailing)
            } //: HSTACK

            ScrollView(.vertical, showsIndicators: false) {
                Text("lkadflkj")
            } //: SCROLL.V
        } //: VSTACK
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
