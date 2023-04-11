//
//  SearchBar.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct SearchBar: View {
    //MARK: - PROPERTIES
    @State var searchText: String = ""
    @State private var isEditing = false
    
    //MARK: - BODY
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            /** Search Bar Field */
            TextField("Search ...", text: $searchText)
        }//: HSTACK
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

//MARK: - PREVIEWS
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
