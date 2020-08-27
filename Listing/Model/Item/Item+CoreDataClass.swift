//
//  Item+CoreDataClass.swift
//  Listing
//
//  Created by Johnny on 24/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    static func create(title: String, index: Int, ofSubList subList: SubList) {
        let createdItem = Item(context: PersistenceService.context)
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
    
}
