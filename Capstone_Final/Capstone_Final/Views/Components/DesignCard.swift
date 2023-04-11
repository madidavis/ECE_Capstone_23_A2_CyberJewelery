//
//  DesignCard.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct DesignCard: View {
    //MARK: - PROPERTIES
    var title: String
    
    //MARK: - BODY
    var body: some View {
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
            VStack {
                Spacer()
                Text(title)
            }//: VSTACK
            .padding()
        }//: ZSTACK
    }
}

struct DesignCard_Previews: PreviewProvider {
    static var previews: some View {
        DesignCard(title: "New Design")
    }
}
