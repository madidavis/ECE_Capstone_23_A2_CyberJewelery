//
//  BrightnessSlider.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct BrightnessSlider: View {
    //MARK: - PROPERTIES
    @ScaledMetric var cardSpacing = 10.0
    @ScaledMetric var cardPadding = 14.0
    @ScaledMetric var iconSize = 25
    
    //MARK: - FUNCTIONS
    //MARK: - BODY
    var body: some View {
        ZStack {
            //MARK: - BARCKGROUND
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemGray6))
            
            //MARK: - CONTENT
            HStack(spacing: cardPadding) {
                /* Icon */
                Image(systemName: "sun.max")
                    .frame(width: iconSize, height: iconSize)
                
                
                /* Text */
                VStack(alignment: .leading, spacing: cardSpacing) {
                    Text("Display Brightness")
                        .font(.headline)
                    Text("100%")
                        .font(.headline)
                        .fontWeight(.regular)
                }
                
                Spacer()
            }
            .padding(cardPadding)
        }
    }
}

struct BrightnessSlider_Previews: PreviewProvider {
    static var previews: some View {
        BrightnessSlider()
    }
}
