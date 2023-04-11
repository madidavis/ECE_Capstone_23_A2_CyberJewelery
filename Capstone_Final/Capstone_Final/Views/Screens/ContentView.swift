//
//  ContentView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 6/4/2023.
//

import SwiftUI


struct ContentView: View {
    //MARK: - PROPERTIES
    /** View Model */
    @ObservedObject var viewModel = ContentViewModel()
    
    //MARK: - BODY
    var body: some View {
            // If Connected BLE Device Detected
        if viewModel.isDeviceConnected {
                // If new design connected load design page
                // Go to Device Base View

            BaseScreenView()
                
        } else {
                // Otherwise -> Go Bluetooth Search
               BluetoothListView()
        }

                    
                    
    }

}


//MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel(dataManager: DataManager.shared))
    }
}

