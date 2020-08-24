//
//  MainList+CoreDataClass.swift
//  Listing
//
//  Created by Johnny on 24/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MainList)
public class MainList: NSManagedObject {
    
    static func create(title: String, emoji: String, index: Int) {
        let createdMainList = MainList(context: PersistenceService.context)
        createdMainList.title = title
        createdMainList.emoji = emoji
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
}
