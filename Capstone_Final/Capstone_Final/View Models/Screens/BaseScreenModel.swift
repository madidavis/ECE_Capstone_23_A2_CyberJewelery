//
//  BaseScreenModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation

@MainActor
class BaseScreenViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /** */
    /** Access Data Manager */
    @Published private var dataManager: DataManager
    @Published var newDesignModel: DesignModel?
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    
    //MARK: - DATA OBJECT REFERENCES
    /* Get Devices that is Currently Edited */
    func getCurrentlyEditing() -> DesignModel? {
        // Get Current Entity
        if let design = dataManager.getCurrentEdit() {
            // return Model
            let designModel = dataManager.getDesignModel(with: design.id!)
            return designModel
        }
        print("Design doesn't exist")
        return nil
    }
    
    /* Load Current Design Model into View Model for Transition */
    func loadCurrentDesign() {
        if let designModel = getCurrentlyEditing() {
            newDesignModel = designModel
        }
    }
}
