//
//  PersistentController.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "SongModel")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error), \(error.userInfo)")
            }
        }
    }
}
