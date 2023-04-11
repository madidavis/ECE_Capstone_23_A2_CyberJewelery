//
//  DeviceInfoCard.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct DeviceInfoCard: View {
    //MARK: - PROPERTIES
    var headerText : String
    var valueText : String
    
    /* Layout & Spacing */
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
            HStack {
                VStack(alignment: .leading, spacing: cardSpacing) {
                    // Icon
                    Image(systemName: "battery.100")
                        .frame(width: iconSize, height: iconSize)
                    //Title
                    Text(headerText)
                        .font(.headline)
                    // Value
                    Text(valueText)
                        .font(.headline)
                        .fontWeight(.regular)
                }//: VSTACK
                
                Spacer()
            }//: HSTACK
            .padding(cardPadding)
        }//: ZSTACK
    }
}

struct DeviceInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInfoCard(headerText: "Battery Life", valueText: "1hr 15min")
            .previewLayout(.sizeThatFits)
    }
}
