//
//  CoreDataStorage.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStorage {
    static var shared = CoreDataStorage()
    
    private init() {}
    
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        print(NSPersistentContainer.defaultDirectoryURL())
        
        let container = NSPersistentContainer(name: "Listing")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var managedOM: NSManagedObjectModel {
        guard let modelURL = Bundle.main.url(forResource: "Listing",
                                             withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        return mom
    }
    
    lazy var coordinatoor: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedOM)
    
    var context: NSManagedObjectContext {
        
        let context = persistentContainer.viewContext
        context.persistentStoreCoordinator = coordinatoor
        
        return context
    }
    
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                /// TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
}
