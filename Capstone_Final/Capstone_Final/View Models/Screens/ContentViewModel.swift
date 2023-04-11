//
//  ContentViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 7/4/2023.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /** State Variable Definitions */
    @Published var isDeviceConnected = true
    

    
    /** Access Data Manager */
    @Published private var dataManager: DataManager
    
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    
    //MARK: - DATA OBJECT REFERENCES
    /** Design References */
    var devices: [DeviceModel] {
        dataManager.devicesArray
    }

}
