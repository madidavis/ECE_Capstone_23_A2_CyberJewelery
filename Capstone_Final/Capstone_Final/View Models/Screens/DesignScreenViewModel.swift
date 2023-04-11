//
//  DesignScreenViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation

@MainActor
class DesignScreenViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /* Access Data Manager */
    @Published private var dataManager: DataManager
    
    /* Current Design */
    @Published var currentDesignModel: DesignModel?
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared, currentDesignModel: DesignModel?) {
        self.dataManager = dataManager
        self.currentDesignModel = currentDesignModel
    }
    
    
    //MARK: - DATA OBJECT REFERENCES
    //MARK: - DESIGNS
    /* - Properties - */
    var designs: [DesignModel] {
        dataManager.designsArray
    }
    
    /* - Fetch Requests & Filter Methods - */
    
    
}
