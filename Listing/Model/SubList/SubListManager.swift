//
//  SubListManager.swift
//  Listing
//
//  Created by Johnny on 24/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import CoreData

class SubListManager {
    
    static let context = PersistenceService.context
    
    static var subLists: [SubList] {
        return fetchSubListFromDatabase()
    }
    
    static func fetchSubListFromDatabase() -> [SubList] {
        var tempSubLists = [SubList]()
        do {
            let request = SubList.fetchRequest() as NSFetchRequest<SubList>
            request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
                   
            tempSubLists = try context.fetch(request)
        } catch { }
               
        return tempSubLists
    }
    
    static func append(title: String, emoji: String, ofMainList mainList: MainList) {
        SubList.create(title: title, emoji: emoji, index: subLists.count,
                       ofMainList: mainList)
    }
    
    static func remove(at index: Int) {
        // Identify removed Main List
        let removedSubList = self.subLists[index]
        // Update index for others
        if subLists.count > 1 {
         for i in 0...subLists.count - 1 {
            if subLists[i].index > index {
//                     replaceIndex(at: i, for: i-1)
                subLists[i].updateIndex(with: i-1)
                }
            }
        }
        // Delete from database
        self.context.delete(removedSubList)

        saveSubList()
    }
    
    static func move(from source: IndexPath, to destination: IndexPath) {
        let movedSubList = self.subLists[source.row]
        
        remove(at: source.row)
        insert(movedSubList, at: destination.row)
    }
    
    static func insert(_ subList: SubList, at insertedIndex: Int) {
        if insertedIndex == subLists.count {
            append(title: subList.title!, emoji: subList.emoji!, ofMainList: subList.ofMainList!) }
        
        else {
            for i in stride(from: subLists.count-1, through: 0, by: -1) {
            if subLists[i].index >= insertedIndex {
                    subLists[i].updateIndex(with: i+1)
                }
            }
            
            SubList.create(title: subList.title!, emoji: subList.emoji!, index: insertedIndex, ofMainList: subList.ofMainList!)
            
        }
    }
    
    // MARK: - Convinience Method
    // IndexPath Update
    static func replaceIndex(at source: Int, for value: Int) {
        let currentSubList = self.subLists[source]

        currentSubList.index = Int64(value)

        saveSubList()
    }
    
    static func saveSubList() {
        do {
            try self.context.save()
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    
}
