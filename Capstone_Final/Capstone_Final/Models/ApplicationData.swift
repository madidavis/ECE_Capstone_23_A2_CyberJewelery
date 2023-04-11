//
//  ApplicationData.swift
//  Capstone_Final
//
//  Created by Madi Davis on 6/4/2023.
//

import Foundation
import CoreData


class ApplicationData {
    //MARK: - PROPERTIES
    /* Create NSPeristentContainer object to define Core Data Stack*/
    let container: NSPersistentContainer
    static let shared = ApplicationData()
    
    /* Create Reference to Context */
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    

    
    
    //MARK: - PREVIEW INSTANCE
    static var preview: ApplicationData = {
        print("preview")
        let model = ApplicationData(inMemory: true)
        let viewContext = model.viewContext
        
        /** Set Up Test values */
        for _ in 0..<10 {
            let testDevice = Device(context: viewContext)
            testDevice.name = "My Test"
            testDevice.id = UUID()
            testDevice.brightness = 0
            testDevice.address = 0
            testDevice.battery_life = 0
        }
        for _ in 0..<10 {
            let newItem = Design(context: viewContext)
            newItem.id = UUID()
            newItem.name = "name test"
        }
        
        /** Save Context */
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return model
    }()
    
    
    
    //MARK: - INITIALISATION
    init(inMemory: Bool = false) {
        print("Application Data Init")
        /* Initialise Container*/
        container = NSPersistentContainer(name: "capstone")
        /* Setup to automatically merge changes in the store & context*/
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        /* Set up Persistent store for Preview */
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
        }
        
        
        /* Load Persistent Stores to container */
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
    }
    
    //MARK: - SAVE CONTEXT
    func saveContext () {
        if viewContext.hasChanges {
            do {
                    try viewContext.save()
                } catch let error as NSError {
                    NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
                }
            }
        }
    
    
    
    
    //MARK: - DESIGN HELPER FUNCTIONS
    func getAllDevices() -> [Device] {
        let deviceFetchRequest: NSFetchRequest<Device> = Device.fetchRequest()
        do {
            return try viewContext.fetch(deviceFetchRequest)
        } catch {
            return []
        }
    }
}

