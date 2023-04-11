//
//  Capstone_FinalApp.swift
//  Capstone_Final
//
//  Created by Madi Davis on 6/4/2023.
//

import SwiftUI

@main
struct Capstone_FinalApp: App {
    var dataManager = DataManager.shared
    var newDesignSet: Bool = false
    
    var body: some Scene {
        WindowGroup {
            //MARK: - CORE DATA SETUP
            /* Inject the context into the Application Environment */
            //let appData = ApplicationData.shared
            
            ContentView()
        }
    }
}
