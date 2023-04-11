//
//  AddDesignViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//  https://github.com/exyte/PopupView/blob/master/Source/PopupView.swift
//

import Foundation
import SwiftUI

@MainActor
class addDesignViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /* Access Data Manager */
    @Published private var dataManager: DataManager
    
    /* User Action Variables */
    @Published var newDesignTitle: String = ""
    
    
    /* Sizing and Layout */
    
    
    
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    
    //MARK: - DATA OBJECT REFERENCES
    var designs: [DesignModel] {
        dataManager.designsArray
    }
    
    /* - Fetch Requests & Filter Methods - */
    /* Get Devices that is Currently Edited */
    func addNewDesign() {
        // Get Design Name from Text Field
        let designName = String(newDesignTitle)
        if designName != "" {
            // Clear Current Design in Edit Mode
            dataManager.clearCurrentEdit()
            // Create New Design Model
            var design = DesignModel()
            design.name = designName
            // Update Database and Save
            dataManager.updateAndSaveEntity(designModel: design)
            // Clear Text Field
            newDesignTitle = ""
        }
    }
    
}
