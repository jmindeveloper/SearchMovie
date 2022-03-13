//
//  CustomShape.swift
//  SearchMovie
//
//  Created by J_Min on 2022/03/13.
//

import SwiftUI

struct CustonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

struct CustonShape_Previews: PreviewProvider {
    static var previews: some View {
        CustonShape()
            .previewLayout(.fixed(width: 428, height: 120))
            .padding()
    }
}
