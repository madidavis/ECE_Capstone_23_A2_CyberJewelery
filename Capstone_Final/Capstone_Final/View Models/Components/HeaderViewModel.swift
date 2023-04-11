//
//  HeaderViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 9/4/2023.
//

import Foundation
@MainActor
class HeaderViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /** Access Data Manager */
    @Published private var dataManager: DataManager
    
    /* Button Functions*/
    
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager

    }
    
    
    //MARK: - DATA OBJECT REFERENCES
    var designs: [DesignModel] {
        dataManager.designsArray
    }
}
