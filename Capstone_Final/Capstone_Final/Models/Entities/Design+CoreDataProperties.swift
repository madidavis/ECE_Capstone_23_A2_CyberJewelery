//
//  Design+CoreDataProperties.swift
//  Capstone_Final
//
//  Created by Madi Davis on 7/4/2023.
//
//

import Foundation
import CoreData


extension Design {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Design> {
        return NSFetchRequest<Design>(entityName: "Design")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var pixel_array: [Int]?
    @NSManaged public var device: Device?
    @NSManaged public var currently_editing: Bool
    
    


}

// MARK: DESIGN EXTENSION --> TRANSFORM FIELD TYPES
/** @note   :   Map Entity fields to data type suitable for view model*/
extension Design : Identifiable {
    /* Map ID to UUID String to Store Current Design */
    func getDesignIDString() -> String {
        return id?.uuidString ?? ""
    }

}
