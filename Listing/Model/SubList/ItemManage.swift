//
//  ItemManage.swift
//  Listing
//
//  Created by Johnny on 25/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

enum Direction {
    case top
    case bottom
}

extension SubList {
    func addItem(_ item: Item) {
        
    }
    
    func addItem(title: String, from position: Direction) {
        switch position {
        case .top:
            self.insertItem(title, at: 0)
        case .bottom:
            Item.create(title: title, index: itemsArray.count, ofSubList: self)
        }
    }
    
    func deleteItem(at index: Int) {
        let removedItem = self.itemsArray[index]
                // Update index for others
        if itemsArray.count > 1 {
            for i in 0...itemsArray.count - 1 {
                if itemsArray[i].index > index {
        //                     replaceIndex(at: i, for: i-1)
                itemsArray[i].updateIndex(with: i-1)
                }
            }
        }
        self.removeFromItems(removedItem)
        // Delete from database
        PersistenceService.context.delete(removedItem)

        PersistenceService.saveContext()
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int) {
        
        let movedItem = self.itemsArray[startIndex]
        
        deleteItem(at: startIndex)
        insertItem(movedItem.title!, at: endIndex)
    }
    
    func insertItem(_ title: String, at insertedIndex: Int) {
        if insertedIndex == itemsArray.count {
            addItem(title: title, from: .bottom)
        }
        
        else {
            for i in stride(from: itemsArray.count-1, through: 0, by: -1) {
            if itemsArray[i].index >= insertedIndex {
                    itemsArray[i].updateIndex(with: i+1)
                }
            }
            
            Item.create(title: title, index: insertedIndex, ofSubList: self)
        }
    }
    
}
