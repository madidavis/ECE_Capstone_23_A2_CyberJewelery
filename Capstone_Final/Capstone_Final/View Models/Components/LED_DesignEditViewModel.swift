//
//  LED_DesignEditViewModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 10/4/2023.
//  vm cache: https://gist.github.com/gdavis/8546b6335ccf3643165c898b6ba7e1b4
//

import Foundation
import SwiftUI

@MainActor
class LED_DesignEditViewModel: ObservableObject {
    //MARK: - PROPERTIES
    
    /** Access Data Manager */
    @Published private var dataManager: DataManager
    
    //MARK: - CHILD VIEW MODELS
    /** Create Cache to store references to child view models - i.e. all individual cells */
    @Published var cellVMCache: [LED_CellEditViewModel] = []
    var numChildViews: Int = 64
    
    /** Array to reference currently selected cells to update in pixel array*/
    @Published var selectedCellVM: [LED_CellEditViewModel] = []
    
    
    //MARK: - INITIALISATION
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        initChildViewModels()
    }
    
    
    //MARK: - LED CELL - CHILD VIEW MODELS
    /* Create View Model Cache */
    func initChildViewModels() {
        for idx in 0...numChildViews {
            cellVMCache.append(LED_CellEditViewModel(dataManager: DataManager.shared, idx: idx))
        }
    }
    
    /* Get All Currently Selected Cells in Array */
    func getCurrentlySelectedCells() {
        let selected = cellVMCache.filter {$0.isSelected}
        selectedCellVM = selected
    }
}
