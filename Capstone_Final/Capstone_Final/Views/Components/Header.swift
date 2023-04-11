//
//  Header.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct Header: View {
    //MARK: - PROPERTIES
    
    
    /* View Model */
    
    //MARK: - BODY
    var body: some View {
    
        HStack {
            //MARK: - LEADING BUTTON
            Button("left"){}
                .buttonStyle(HeaderButton())
            
            Spacer()
            
            //MARK: - TITLE
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Spacer()
            //MARK: - TRAILING BUTTON
            Button("right"){}
                .buttonStyle(HeaderButton())
            
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
