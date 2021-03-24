//
//  SubListEntity+CoreDataClass.swift
//  Listing
//
//  Created by Johnny on 24/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SubListEntity)
public class SubListEntity: NSManagedObject {
    static func create(title: String, emoji: String, index: Int, ofMainList mainList: MainListEntity) {
        let createdSubList = SubListEntity(context: PersistenceService.context)
        createdSubList.title = title
        createdSubList.emoji = emoji
        createdSubList.index = Int64(index)

        createdSubList.ofMainList = mainList
        
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
    
    var itemsArray: [ItemEntity] {
        return items!.toArray().sorted(by: {$0.index < $1.index})
    }
    
    func toDomain() -> DomainSubList {
        guard title != nil else {
            fatalError("Fix title to be not optional")
        }
        
        let id = objectID.uriRepresentation().absoluteString
        
        return .init(storageID: id, title: title!, emoji: emoji, index: Int(index))
    }
}
