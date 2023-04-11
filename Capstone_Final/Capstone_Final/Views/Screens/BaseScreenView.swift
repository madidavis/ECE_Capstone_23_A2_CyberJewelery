//
//  BaseScreenView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct BaseScreenView: View {
    //MARK: - PROPERTIES
    /** NAVIGATION PROPERTIES **/
    /** View Model */
    @ObservedObject var viewModel = BaseScreenViewModel()
    @State var currentView = "Device"
    //MARK: - FUNCTIONS

    //MARK: - BODY
    
    var body: some View {
        TabView(selection: $currentView) {

            //MARK: - DEVICE SCREEN NAV
            DeviceScreenView()
                .tabItem {
                    Label("Device", systemImage: "house")
                }
            
            //MARK: - DESIGN SCREEN NAV
            
            DesignScreenView(currentDesignModel: viewModel.newDesignModel ?? nil)
                .tabItem {
                    Label("Design", systemImage: "clipboard")
                }
            
            //MARK: - LIBRARY SCREEN NAV
            LibraryScreenView()
                .tabItem {
                    Label("Library", systemImage: "book")
                }
        }//: TAB VIEW
        .onAppear(perform: {
            viewModel.loadCurrentDesign()
        })
    }
        
        
}

struct BaseScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BaseScreenView(viewModel: BaseScreenViewModel(dataManager: DataManager.shared))
    }
}
