//
//  SubList+CoreDataClass.swift
//  Listing
//
//  Created by Johnny on 24/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SubList)
public class SubList: NSManagedObject {
    
    static func create(title: String, emoji: String, index: Int, ofMainList mainList: MainList) {
        let createdSubList = SubList(context: PersistenceService.context)
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
    
    var itemsArray: [Item] {
        return items!.toArray().sorted(by: {$0.index < $1.index})
    }
    
}

extension NSSet {
    func toArray<T>() -> [T] {
        return self.map { $0 as! T }
    }
}
