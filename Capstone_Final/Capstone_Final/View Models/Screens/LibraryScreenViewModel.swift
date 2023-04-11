//
//  LibraryScreenViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation

@MainActor
class LibraryScreenViewModel: ObservableObject {
    //MARK: - PROPERTIES
    /* Access Data Manager */
    @Published private var dataManager: DataManager
    
    /* Add New Design Variables */
    @Published var showNewDesignModal = false
    @Published var newDesignModel: DesignModel?
    
    /* Layout & Sizing Dimensions */
    @Published var screenContentDim: CGRect = .zero
    
    
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
            print("load")
        }
    }
}

