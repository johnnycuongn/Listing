//
//  ItemEntity+CoreDataClass.swift
//  Listing
//
//  Created by Johnny on 24/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ItemEntity)
public class ItemEntity: NSManagedObject {
    static func create(title: String, index: Int, ofSubList subList: SubListEntity) {
        let createdItem = ItemEntity(context: PersistenceService.context)
        createdItem.title = title
        createdItem.index = Int64(index)
        createdItem.ofSubList = subList
        
        PersistenceService.saveContext()
    }
    
    func updateTitle(with newTitle: String) {
        self.title = newTitle
        
        PersistenceService.saveContext()
    }
    
    func updateIndex(with newIndex: Int) {
        self.index = Int64(newIndex)
        
        PersistenceService.saveContext()
    }
    
    func updateComplete() {
        self.isCompleted = !isCompleted
        
        PersistenceService.saveContext()
    }
    
    func updateComplete(with value: Bool) {
        self.isCompleted = value
        
        PersistenceService.saveContext()
    }
    
    func toDomain() -> DomainItem {
        guard title != nil else {
            fatalError("Fix title to be not optional")
        }
        
        let id = objectID.uriRepresentation().absoluteString
        
        return .init(storageID: id, title: title!, index: Int(index), isCompleted: isCompleted)
    }
}
