//
//  ItemManage.swift
//  Listing
//
//  Created by Johnny on 25/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

extension SubList {
    func addItem(_ item: Item) {
        
    }
    
    func addItem(title: String) {
        Item.create(title: title, index: itemsInList.count, ofSubList: self)
    }
    
    func deleteItem(at index: Int) {
        let removedItem = self.itemsInList[index]
                // Update index for others
        if itemsInList.count > 1 {
            for i in 0...itemsInList.count - 1 {
                if itemsInList[i].index > index {
        //                     replaceIndex(at: i, for: i-1)
                itemsInList[i].updateIndex(with: i-1)
                }
            }
        }
        self.removeFromItems(removedItem)
        // Delete from database
        PersistenceService.context.delete(removedItem)

        PersistenceService.saveContext()
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int) {
        
        let movedItem = self.itemsInList[startIndex]
        
        deleteItem(at: startIndex)
        insertItem(movedItem, at: endIndex)
    }
    
    func insertItem(_ item: Item, at insertedIndex: Int) {
        if insertedIndex == itemsInList.count {
            addItem(title: item.title!)
        }
        
        else {
            for i in stride(from: itemsInList.count-1, through: 0, by: -1) {
            if itemsInList[i].index >= insertedIndex {
                    itemsInList[i].updateIndex(with: i+1)
                }
            }
            
            Item.create(title: item.title!, index: insertedIndex, ofSubList: self)
        }
    }
    
}
