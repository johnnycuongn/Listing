//
//  MainListEntity+CoreDataClass.swift
//  Listing
//
//  Created by Johnny on 24/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MainListEntity)
public class MainListEntity: NSManagedObject {
    static func create(title: String, emoji: String, index: Int) {
        let createdMainList = MainListEntity(context: PersistenceService.context)
        createdMainList.title = title
        createdMainList.emoji = emoji
            createdMainList.index = Int64(index)
        
        PersistenceService.saveContext()
    }
    
    static func create(title: String, index: Int) {
        let createdMainList = MainListEntity(context: PersistenceService.context)
        createdMainList.title = title
        createdMainList.index = Int64(index)
        
        PersistenceService.saveContext()
    }
    
    func updateTitle(with newTitle: String) {
        self.title = newTitle
        
        PersistenceService.saveContext()
    }
    
    func updateEmoji(with newEmoji: String) {
        self.emoji = newEmoji
        
        PersistenceService.saveContext()
    }
    
    func updateIndex(with newIndex: Int) {
        self.index = Int64(newIndex)
        
        PersistenceService.saveContext()
    }
    
    var subListsArray: [SubListEntity] {
        return subLists!.toArray().sorted {$0.index < $1.index}
    }
    
    func toDomain() -> DomainMasterList {
        guard title != nil else {
            fatalError("Fix title to be not optional")
        }
        
        let id = objectID.uriRepresentation().absoluteString
        
        return .init(storageID: id, title: title!, emoji: emoji, index: Int(index))
    }

}
