//
//  DeviceModel.swift
//  Capstone_Final
//
//  Created by Madi Davis on 7/4/2023.
//

import Foundation

/** Model Definition of Device Core Data Entity --> both are synced with Data Manager */
struct DeviceModel: Identifiable, Hashable {
    //MARK: - ATTRIBUTES
    var id: UUID
    var name: String
    var address: Int32
    var battery_life: Int32
    var brightness: Int32
    var is_connected: Bool
    var current_design: UUID?
    var designIDs = [UUID]()
    
    //MARK: - INITIALISATION
    init(name: String = "") {
        self.id = UUID()
        self.name = name
        self.address = 0
        self.battery_life = 0
        self.brightness = 0
        self.is_connected = false
        self.current_design = UUID()
        
    }
}

//MARK: - DEVICE MODEL EXTENSION -> RELATIONSHIP HELPERS
extension DeviceModel {
    /* Map ID to UUID String to Store Current Design */
    func getDesignIDString() -> String {
        // Check if current design is assigned
        let curr_id = current_design ?? nil
        if curr_id == nil {
            return ""
        } else {
            return curr_id!.uuidString
        }
    }
}
