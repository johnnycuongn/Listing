//
//  ManageSubList.swift
//  Listing
//
//  Created by Johnny on 25/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

extension MainList {
    func addSubList(title: String, emoji: String) {
        SubList.create(title: title, emoji: emoji, index: subListsArray.count, ofMainList: self)
    }
    
    func deleteSubList(at index: Int) {
        // Identify removed Main List
        let removedSubList = self.subListsArray[index]
        // Update index for others
        if subListsArray.count > 1 {
            for i in 0...subListsArray.count - 1 {
            if subListsArray[i].index > index {
        //                   replaceIndex(at: i, for: i-1)
                subListsArray[i].updateIndex(with: i-1)
                }
            }
        }
        // Delete from database
        self.removeFromSubLists(removedSubList)
        PersistenceService.context.delete(removedSubList)
        
        PersistenceService.saveContext()
    }
    
    func moveSubList(from startIndex: Int, to endIndex: Int) {
        let movedSubList = subListsArray[startIndex]
        
        deleteSubList(at: startIndex)
        insert(movedSubList, at: endIndex)
    }
    
    
    
    func insert(_ subList: SubList, at insertedIndex: Int) {
        if insertedIndex == subListsArray.count {
            addSubList(title: subList.title!, emoji: subList.emoji!)
        }
        
        else {
            for i in stride(from: subListsArray.count-1, through: 0, by: -1) {
            if subListsArray[i].index >= insertedIndex {
                    subListsArray[i].updateIndex(with: i+1)
                }
            }
            
            SubList.create(title: subList.title!, emoji: subList.emoji!, index: insertedIndex, ofMainList: subList.ofMainList!)
        }
    }
    
    
}
