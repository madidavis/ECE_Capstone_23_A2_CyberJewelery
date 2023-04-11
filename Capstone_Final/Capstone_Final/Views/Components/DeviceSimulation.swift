//
//  DeviceSimulation.swift
//  CaptstoneA2
//
//  Created by Madi Davis on 3/4/2023.
//

import SwiftUI

struct DeviceSimulation: View {
    //MARK: - PROPEPTIES
    let gridColumns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
    ]
    //MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(.systemGray6))
                .frame(width:362 ,height: 390)
                .padding(20)
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(0..<64) { item in
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.gray)
                        .frame(width:30 ,height:30)
                }
                
            }//: LAZYVSTACK
            .padding(20)
        }//: ZSTACK
    }
}

struct DeviceSimulation_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSimulation()
    }
}
