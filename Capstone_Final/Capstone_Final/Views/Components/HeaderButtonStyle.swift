//
//  HeaderButtonStyle.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct HeaderButton: ButtonStyle {
    //MARK: - PROPERTIES
    @Environment(\.isEnabled) private var isEnabled
    
    //MARK: - CONFIGURATION
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(isEnabled ? Color.accentColor : .gray)
            .cornerRadius(10)
    }
}
