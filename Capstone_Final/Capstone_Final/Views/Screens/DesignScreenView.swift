//
//  DesignScreenView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct DesignScreenView: View {
    //MARK: - PROPERTIES
    /** View Model */
    @ObservedObject var viewModel: DesignScreenViewModel
    
    init(dataManager: DataManager = DataManager.shared, currentDesignModel: DesignModel?) {
        self.viewModel = DesignScreenViewModel(dataManager: dataManager, currentDesignModel: currentDesignModel)
    }

    
    //MARK: - FUNCTIONS

    //MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    //MARK: - HEADER
                    HStack {
                        //MARK: - LEADING BUTTON
                        Button("left"){
                            print("left pressed")
                        }
                        .buttonStyle(HeaderButton())
                        
                        Spacer()
                        
                        //MARK: - TITLE
                        Text(viewModel.currentDesignModel?.name ?? "Design Name")
                        
                        Spacer()
                        //MARK: - TRAILING BUTTON
                        Button("right"){
                            print("right pressed")
                        }
                        .buttonStyle(HeaderButton())
                        
                    } //: HSTACK
                    Spacer()
                    //MARK: - DESIGN EDIT SIMULATOR
                    LED_DesignEdit()
                    Spacer()
                    
                    //MARK: - DESIGN EDIT SCREEN
                    //DesignControlsView(height: (geometry.size.height*0.2), width: geometry.size.width)
                        //.ignoresSafeArea()
                    
                }//: VSTACK
                
            }//:ZSTACK
        }//: GEOMETRY READER
    }
}

struct DesignScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DesignScreenView(dataManager: DataManager.shared, currentDesignModel: DesignModel())
    }
}
