//
//  BluetoothListViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation

@MainActor
class BluetoothListViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /** Access Data Manager */
    @Published private var dataManager: DataManager
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    
    //MARK: - DATA OBJECT REFERENCES
    var designs: [DesignModel] {
        dataManager.designsArray
    }
}

