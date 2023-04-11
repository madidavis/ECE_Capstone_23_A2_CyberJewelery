//
//  DataManager.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import Foundation
import CoreData
import OrderedCollections

//MARK: - DATA MANAGER CLASS DEFN
class DataManager : NSObject, ObservableObject {
    //MARK: - PROPERTIES
    /**Data Manager */
    static let shared = DataManager()
    
    /* Define Object Context  */
    fileprivate var managedObjectContext: NSManagedObjectContext
    
    /* Fetch Results Controllers for Entities */
    private let designsFRC: NSFetchedResultsController<Design>
    private let devicesFRC: NSFetchedResultsController<Device>
    
    /* Data Structures to Store Fetched Entities */
    @Published var devices: OrderedDictionary<UUID, DeviceModel> = [:]
    var devicesArray: [DeviceModel] {
        Array(devices.values)
    }
    @Published var designs: OrderedDictionary<UUID, DesignModel> = [:]
    var designsArray: [DesignModel] {
        Array(designs.values)
    }
    
    //MARK: - INITIALISATION
    private override init() {
        print("data manager init")
        let appData = ApplicationData()
        self.managedObjectContext = appData.viewContext
        
        /* Make Test Objects */
        /** Test Devices */
        let newDevice = Device(context: managedObjectContext)
        newDevice.id = UUID()
        newDevice.name = "Test Device"
        try? self.managedObjectContext.save()
        
        /** Test Designs */
        let newDesign = Design(context: managedObjectContext)
        newDesign.id = UUID()
        newDesign.name = "Test Design"
        try? self.managedObjectContext.save()
        
        
        /* Fetch Entities */
        let deviceFR: NSFetchRequest<Device> = Device.fetchRequest() //**< Fetch Request
        deviceFR.sortDescriptors = []
        devicesFRC = NSFetchedResultsController(fetchRequest: deviceFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let designFR: NSFetchRequest<Design> = Design.fetchRequest() //**< Fetch Request
        designFR.sortDescriptors = []
        designsFRC = NSFetchedResultsController(fetchRequest: designFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        /* Save Initial Fetched Values into Arrays */
        designsFRC.delegate = self
        try? designsFRC.performFetch()
        print("test")
        if let newDesigns = designsFRC.fetchedObjects {
            print(newDesigns)
            self.designs = OrderedDictionary(uniqueKeysWithValues: newDesigns.map({($0.id!, DesignModel(design: $0))}))
            // note: $0 --> first index --> map id to data model built from entity
        }
        
        devicesFRC.delegate = self
        try? devicesFRC.performFetch()
        if let newDevices = devicesFRC.fetchedObjects {
            print(newDevices)
            self.devices = OrderedDictionary(uniqueKeysWithValues: newDevices.map({($0.id!, DeviceModel(device: $0))}))
            // note: $0 --> first index --> map id to data model built from entity
        }
    }
        
    //MARK: - SAVE
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
}

//MARK: - DATA MANAGER EXTENSION --> FETCH REQUESTS
extension DataManager: NSFetchedResultsControllerDelegate {
    //MARK: - CONTROLLER CHANGED CONTENT
    /** Function is called by fetch controller when associated fetch results are changed */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // If FRC = Designs Fetch Request Controller
        if let newDesigns = controller.fetchedObjects as? [Design] {
            self.designs = OrderedDictionary(uniqueKeysWithValues: newDesigns.map({($0.id!, DesignModel(design: $0))}))
        } else if let newDevices = controller.fetchedObjects as? [Device] {
            self.devices = OrderedDictionary(uniqueKeysWithValues: newDevices.map({($0.id!, DeviceModel(device: $0))}))
        }
    }
    
    //MARK: - FETCH SINGLE OBJECT
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    //MARK: - FETCH DESIGN GIVEN PREDICATE & SORT DESCRIPTOR
    /* Fetch Designs */
    func fetchDesigns(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        // Define predicate
        if let predicate = predicate {
            designsFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            designsFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        do {
            try designsFRC.performFetch()
            if let newDesigns = designsFRC.fetchedObjects {
                self.designs = OrderedDictionary(uniqueKeysWithValues: newDesigns.map({($0.id!, DesignModel(design: $0))}))
            }
        }
        catch {
                print("error - failed to fetch designs")
        }
    }
    
    /* Fetch Devices */
    func fetchDevices(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        // Define predicate
        if let predicate = predicate {
            devicesFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            devicesFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        do {
            try devicesFRC.performFetch()
            if let newDesigns = devicesFRC.fetchedObjects {
                self.devices = OrderedDictionary(uniqueKeysWithValues: newDesigns.map({($0.id!, DeviceModel(device: $0))}))
            }
        }
        catch {
                print("error - failed to fetch designs")
        }
    }

    //MARK: - CLEAR CUSTOM FETCH RESULTS DICTIONARY TO ALL RESULTS
    /* Reset Device Fetch */
    func resetDeviceFetch() {
        devicesFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        devicesFRC.fetchRequest.predicate = nil
        try? devicesFRC.performFetch()
        if let clearedDevices = devicesFRC.fetchedObjects {
            self.devices = OrderedDictionary(uniqueKeysWithValues: clearedDevices.map({ ($0.id!, DeviceModel(device: $0)) }))
        }
    }
    
    /* Reset Design Fetch */
    func resetDesignFetch() {
        designsFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        designsFRC.fetchRequest.predicate = nil
        try? designsFRC.performFetch()
        if let clearedDesigns = designsFRC.fetchedObjects {
            self.designs = OrderedDictionary(uniqueKeysWithValues: clearedDesigns.map({ ($0.id!, DesignModel(design: $0)) }))
        }
    }
     
}


//MARK: - DEVICE METHODS
//MARK: - DEVICE EXTENSION --> MAP ENTITY TO DEVICE MODEL STRUCT
/** Extend Device to Sync Data Model with Core Data Entity */
extension DeviceModel {
    fileprivate init(device: Device) {
        // Create a New instance of Model with Entity Values
        self.id = device.id ?? UUID()
        self.name = device.name ?? ""
        self.address = 0
        self.is_connected = false
        self.battery_life = 0
        self.brightness = 0
        self.current_design = device.getCurrentDesignID()
    }
}

//MARK: - DATA MANAGER EXTENSION --> DEVICE CRUD
/** Get & Update Mirrored Entity Instance of Data Model from  Database*/
extension DataManager {
    //MARK: - GET FUNCTIONS
    /** Get Model from ID */
    func getDeviceModel(with id: UUID) -> DeviceModel? {
        return devices[id]
    }
    
    /** Get Entity from ID */
    func getDevice(id: UUID?) -> Device? {
        // Check ID is not nil
        if id == nil {
            print("Invalid - ID is nil")
            return nil
        }
            
        let getPredicate = NSPredicate(format: "id=%@", id! as CVarArg)
        let getFetchResult = fetchFirst(Device.self, predicate: getPredicate)
        
        switch getFetchResult {
        case .success(let managedObject):
            if let device = managedObject {
                // update from model
                return device
            }
        case .failure(_):
            print("Could not Find Existing Device Entity with ID")
        }
        return nil
    }
    
    //MARK: - MAPPING MODEL/ENTITY METHODS
    /** Get & Update Mirrored Entity Instance of Data Model from  Database*/
    private func deviceModelToEntity(from deviceModel: DeviceModel) {
        // Get Entity & map ID
        let device = Device(context: managedObjectContext)
        device.id = deviceModel.id
        // Update additional Properties
        updateFromModel(device: device, from: deviceModel)
    }
    
    //MARK: - UPDATE ENTITY METHODS
    /** Helper - Update Enity from Data Model  */
    private func updateFromModel(device: Device, from deviceModel: DeviceModel) {
        device.name = deviceModel.name
        device.address = deviceModel.address
        device.is_connected = deviceModel.is_connected
        device.battery_life = deviceModel.battery_life
        device.brightness = deviceModel.brightness
        device.current_design = deviceModel.getDesignIDString()
    }
    
    /** Pass Updates to Entity to Database and Save  */
    func updateAndSaveEntity(deviceModel: DeviceModel) {
        // Define Predicate for Fetch as Entity/Data Model ID
        let updatePredicate = NSPredicate(format: "id=%@", deviceModel.id as CVarArg)
        let updateFetchResult = fetchFirst(Device.self, predicate: updatePredicate)
        
        switch updateFetchResult {
        case .success(let managedObject):
            if let device = managedObject {
                // update from model
                updateFromModel(device: device, from: deviceModel)
            } else {
                // get entity from model then update
                deviceModelToEntity(from: deviceModel)
            }
        case .failure(_):
            print("Could not Fetch Device to Save")
        }
        saveData()
    }
    
    //MARK: - CREATE ENTITY METHODS
    
    //MARK: - DELETE ENTITY METHODS
    func deleteEntity(deviceModel: DeviceModel) {
        // Define Predicate for Fetch as Entity/Data Model ID
        let deletePredicate = NSPredicate(format: "id=%@", deviceModel.id as CVarArg)
        let deleteFetchResult = fetchFirst(Device.self, predicate: deletePredicate)
        
        switch deleteFetchResult {
        case .success(let managedObject):
            if let device = managedObject {
                managedObjectContext.delete(device)
            }
        case .failure(_):
            print("Could not Fetch Device to Delete")
        }
        saveData()
    }
}




//MARK: - DESIGN METHODS
//MARK: - DESIGN EXTENSION --> MAP ENTITY TO DESIGN MODEL STRUCT
/** Extend Design to Sync Data Model with Core Data Entity */
extension DesignModel {
    fileprivate init(design: Design) {
        // Create a New instance of Model with Entity Values
        self.id = design.id ?? UUID()
        self.name = design.name ?? ""
        self.pixel_array = [Int]()
        self.deviceID = nil // Set to nil until assigned to Device
        print("check")
        self.currently_editing = true
    }
}

//MARK: - DATA MANAGER EXTENSION --> DESIGN CRUD
extension DataManager {
    //MARK: - GET FUNCTIONS
    /** Get Model from ID */
    func getDesignModel(with id: UUID) -> DesignModel? {
    return designs[id]
    }

    /** Get Entity from ID */
    func getDesign(id: UUID?) -> Design? {
        if id == nil {
            print("Invalid - ID is nil")
            return nil
        }
        
        let getPredicate = NSPredicate(format: "id=%@", id! as CVarArg)
        let getFetchResult = fetchFirst(Design.self, predicate: getPredicate)
        
        switch getFetchResult {
        case .success(let managedObject):
            if let design = managedObject {
                // update from model
                return design
            }
        case .failure(_):
            print("Could not Find Existing Design Entity with ID")
        }
        return nil
    }
    
    //MARK: - MAPPING MODEL/ENTITY METHODS
    /** Get & Update Mirrored Entity Instance of Data Model from  Database*/
    private func designModelToEntity(from designModel: DesignModel) {
        // Get Entity & map ID
        let design = Design(context: managedObjectContext)
        design.id = designModel.id
        // Update additional Properties
        updateFromModel(design: design, from: designModel)
    }
    
    //MARK: - UPDATE ENTITY METHODS
    /** Helper - Update Enity from Data Model  */
    private func updateFromModel(design: Design, from designModel: DesignModel) {
        print(designModel)
        design.name = designModel.name
        design.pixel_array = designModel.pixel_array
        design.device = getDevice(id: designModel.deviceID) // Will return nil if not assigned to device
        print("check")
        design.currently_editing = designModel.currently_editing
        print("check")
    }
    
    /** Pass Updates to Entity to Database and Save  */
    func updateAndSaveEntity(designModel: DesignModel) {
        // Define Predicate for Fetch as Entity/Data Model ID
        let updatePredicate = NSPredicate(format: "id=%@", designModel.id as CVarArg)
        let updateFetchResult = fetchFirst(Design.self, predicate: updatePredicate)
        
        switch updateFetchResult {
        case .success(let managedObject):
            if let design = managedObject {
                // update from model
                updateFromModel(design: design, from: designModel)
                print("exit")
            } else {
                // get entity from model then update
                designModelToEntity(from: designModel)
            }
        case .failure(_):
            print("Could not Fetch Design to Save")
        }
        saveData()
    }
    
    //MARK: - CREATE ENTITY METHOD
    
    
    //MARK: - DELETE ENTITY METHODS
    func deleteEntity(designModel: DesignModel) {
        // Define Predicate for Fetch as Entity/Data Model ID
        let deletePredicate = NSPredicate(format: "id=%@", designModel.id as CVarArg)
        let deleteFetchResult = fetchFirst(Design.self, predicate: deletePredicate)
        
        switch deleteFetchResult {
        case .success(let managedObject):
            if let design = managedObject {
                managedObjectContext.delete(design)
            }
        case .failure(_):
            print("Could not Fetch Design to Delete")
        }
        saveData()
    }
    
    
    //MARK: - CUSTOM METHODS
    /* Get Design Currently in Edit Mode */
    func getCurrentEdit() -> Design? {
        // Define predicate
        let editPredicate =  NSPredicate(format: "currently_editing=%@", NSNumber(booleanLiteral: true) as CVarArg)
        let editFetchResult = fetchFirst(Design.self, predicate: editPredicate)
        
        switch editFetchResult {
        case .success(let managedObject):
            if let design = managedObject {
                // update from model
                return design
            }
        case .failure(_):
            print("No Design Currently in Edit Mode")
        }
        return nil
    }
    
    /* Clear Last Design in Edit Mode to Load New Design */
    func clearCurrentEdit() {
        if let currentEdit = getCurrentEdit(){
            //Set Currently Editing to false
            currentEdit.currently_editing = false
            saveData()
        } else {
            print("No design currently in Edit Mode")
        }
    }
}



