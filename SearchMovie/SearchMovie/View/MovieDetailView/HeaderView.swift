//
//  HeaderView.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/13.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let content: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(content)
                .foregroundColor(.black)
        }
        .padding([.bottom, .leading, .trailing])
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "감독", content: "누굴까...")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
