//
//  Device+CoreDataProperties.swift
//  Capstone_Final
//
//  Created by Madi Davis on 7/4/2023.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var address: Int32
    @NSManaged public var battery_life: Int32
    @NSManaged public var brightness: Int32
    @NSManaged public var is_connected: Bool
    @NSManaged public var current_design: String?
    @NSManaged public var designs: NSSet?

}

// MARK: Generated accessors for designs
extension Device {

    @objc(addDesignsObject:)
    @NSManaged public func addToDesigns(_ value: Design)

    @objc(removeDesignsObject:)
    @NSManaged public func removeFromDesigns(_ value: Design)

    @objc(addDesigns:)
    @NSManaged public func addToDesigns(_ values: NSSet)

    @objc(removeDesigns:)
    @NSManaged public func removeFromDesigns(_ values: NSSet)

}

// MARK: DESIGN EXTENSION --> TRANSFORM FIELD TYPES
/** @note   :   Map Entity fields to data type suitable for view model*/
extension Device : Identifiable {
    /* Get Current Design ID from Stored Design String*/
    func getCurrentDesignID() -> UUID? {
        // Check if current design is assigned
        let id_string = current_design ?? ""
        if id_string == "" {
            return nil
        } else {
            return UUID(uuidString: current_design!)
        }
    }
    

    
    
}


