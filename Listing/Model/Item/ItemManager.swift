//
//  ItemManager.swift
//  Listing
//
//  Created by Johnny on 25/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import CoreData

class ItemManager {
    
    static let context = PersistenceService.context
    
    static var itemInList: [Item] {
        return fetchItemFromDatabase()
    }
    
    static func fetchItemFromDatabase() -> [Item] {
        var tempSubLists = [Item]()
        do {
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
                   
            tempSubLists = try context.fetch(request)
        } catch { }
               
        return tempSubLists
    }
    
    static func append(title: String, ofSubList subList: SubList) {
        Item.create(title: title, index: itemInList.count, ofSubList: subList)
    }
    
    static func remove(at index: Int) {
        // Identify removed Main List
        let removedItem = self.itemInList[index]
        // Update index for others
        if itemInList.count > 1 {
         for i in 0...itemInList.count - 1 {
            if itemInList[i].index > index {
//                     replaceIndex(at: i, for: i-1)
                itemInList[i].updateIndex(with: i-1)
                }
            }
        }
        // Delete from database
        self.context.delete(removedItem)

        saveItem()
    }
    
    static func move(from source: IndexPath, to destination: IndexPath) {
        let movedItem = self.itemInList[source.row]
        
        remove(at: source.row)
        insert(movedItem, at: destination.row)
    }
    
    static func insert(_ item: Item, at insertedIndex: Int) {
        if insertedIndex == itemInList.count {
            append(title: item.title!, ofSubList: item.ofSubList!)
        }
        
        else {
            for i in stride(from: itemInList.count-1, through: 0, by: -1) {
            if itemInList[i].index >= insertedIndex {
                    itemInList[i].updateIndex(with: i+1)
                }
            }
            
            Item.create(title: item.title!, index: insertedIndex, ofSubList: item.ofSubList!)
        }
    }
    
    // MARK: - Convinience Method
    // IndexPath Update
    
    static func saveItem() {
        do {
            try self.context.save()
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    
}
