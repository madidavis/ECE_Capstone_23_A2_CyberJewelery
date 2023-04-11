//
//  DesignControlsView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 10/4/2023.
//

import SwiftUI

struct DesignControlsView: View {
    //MARK: - PROPERTIES
    /* Layout & Sizing Properties */
    @ScaledMetric var overlayPadding = 20.0
    var height: CGFloat
    var width: CGFloat
    
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemGray6))
            
            //MARK: - CONTENT
            VStack {
                //MARK: - TAB HEADER
                HStack{
                    Spacer()
                    Text("Hue")
                    Spacer()
                    Text("Motion")
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
        }
    }
}

struct DesignControlsView_Previews: PreviewProvider {
    static var previews: some View {
        DesignControlsView(height: 270, width: 390)
    }
}
