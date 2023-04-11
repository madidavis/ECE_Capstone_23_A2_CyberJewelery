//
//  DeviceScreenView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct DeviceScreenView: View {
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    ZStack{
                        //MARK: BACKGROUND
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color(.systemGray6))
                            .frame(width:390 ,height: 450)
                            .ignoresSafeArea(.all)
                        
                        //MARK: - HEADER
                        VStack{
                            Header()
                                .padding([.leading,.trailing], 20)
                            Spacer()
                        }//: VSTACK
                    }//: ZSTACK
                    
                    //MARK: - DEVICE INFO
                    HStack(spacing: 20){
                        /* Baterry Life */
                        DeviceInfoCard(headerText: "Battery Life", valueText: "1hr 15min")
                        
                        /* Current Design */
                        DeviceInfoCard(headerText: "Battery Life", valueText: "1hr 15min")
                    }//: HSTACK
                    .padding(20)
                    
                    BrightnessSlider()
                        .padding([.leading,.trailing, .bottom], 20)
                    Spacer()
                    
                }
            }//: VSTACK
        }//: ZSTACK
        .ignoresSafeArea(.all, edges: .top)
    }//: NAVIGATION VIEW
}

struct DeviceScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceScreenView()
    }
}
