//
//  DesignModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 7/4/2023.
//

import Foundation
import SwiftUI

/* Model Definition of Design Core Data Entity --> both are synced with Data Manager */
struct DesignModel: Identifiable, Hashable {
    //MARK: - ATTRIBUTES
    var id: UUID
    var name: String
    var pixel_array: [Int]
    var deviceID: UUID?
    var currently_editing: Bool
    
    //MARK: - INITIALISATION
    init(name: String = "") {
        self.id = UUID()
        self.name = name
        self.currently_editing = true
        // Initialise pixel array as a 8x8 array of black
        self.pixel_array = Array(repeating: 0, count: 64)
        self.deviceID = nil
    }
}

//MARK: - DESIGN MODEL EXTENSION -> RELATIONSHIP HELPERS
extension DesignModel {
    /* Map ID to UUID String to Store Current Design */
    func getDesignIDString() -> String {
        return id.uuidString 
    }
}

//MARK: - DESIGN MODEL EXTENSION -> PIXEL ARRAY HELPERS
extension DesignModel {
    /* Get 8x8 array coordinates from pixel index */
    func getRowFromIndex(index: Int) -> Int {
        return index / 8
    }
    
    func getColfromIndex(index: Int) -> Int {
        return index % 8
    }
    
    /* Get pixel index from 8x8 array */
    func indexFromCoords(row: Int, col: Int) -> Int {
        return 8*row + col
    }
    
    /* Convert All RGB Vals to Color*/
}
