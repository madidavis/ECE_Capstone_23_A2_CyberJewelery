//
//  LED_CellEditViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation
import SwiftUI

@MainActor
class LED_CellEditViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /** Access Data Manager */
    @Published private var dataManager: DataManager
    
    /** View Variables */
    @Published var isOn = false
    
    @Published private var color = Color(hex: 0, alpha: 0)
    
    @Published private var row: Int = 0
    @Published private var col: Int = 0
    @Published private var idx: Int
    
    
    /** State Variables */
    @Published var isSelected = false
    
    
    
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared, idx: Int = 0) {
        self.dataManager = dataManager
        self.idx = idx
        
    }
    
    
    //MARK: - UPDATE VIEW FUNCTIONS
    /* Turn On / Off */
    
    
    /* Change Colour */
    
    
    //MARK: - DATA OBJECT REFERENCES
    /* Get Design Current Design */
    var designs: [DesignModel] {
        dataManager.designsArray
    }
    
    /* Get Pixel Array */
    
    /* Update Colour Value */
    
    
    

}
