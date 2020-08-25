//
//  MainListManager.swift
//  Listing
//
//  Created by Johnny on 25/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import CoreData

class MainListManager {
    
    static let context = PersistenceService.context
    
    static var mainLists: [MainList] {
        return fetchMainListFromDatabase()
    }
    
    static func fetchMainListFromDatabase() -> [MainList] {
        var tempMainLists = [MainList]()
        do {
            let request = MainList.fetchRequest() as NSFetchRequest<MainList>
            request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
                   
            tempMainLists = try context.fetch(request)
        } catch { }
               
        return tempMainLists
    }
    
    static func append(title: String, emoji: String) {
        MainList.create(title: title, emoji: emoji, index: mainLists.count)
    }
    
    static func remove(at index: Int) {
        // Identify removed Main List
        let removedMainList = self.mainLists[index]
        // Update index for others
        if mainLists.count > 1 {
         for i in 0...mainLists.count - 1 {
            if mainLists[i].index > index {
//                     replaceIndex(at: i, for: i-1)
                mainLists[i].updateIndex(with: i-1)
                }
            }
        }
        // Delete from database
        self.context.delete(removedMainList)

        saveMainList()
    }
    
    static func move(from source: IndexPath, to destination: IndexPath) {
        let movedMainList = self.mainLists[source.row]
    
        remove(at: source.row)
        insert(movedMainList, at: destination.row)
    }
    
    static func insert(_ mainList: MainList, at insertedIndex: Int) {

        if insertedIndex == mainLists.count {
            append(title: mainList.title!, emoji: mainList.emoji!)
        }
        
        else {
            for i in stride(from: mainLists.count-1, through: 0, by: -1) {
            if mainLists[i].index >= insertedIndex {
                    mainLists[i].updateIndex(with: i+1)
                }
            }
            MainList.create(title: mainList.title!, emoji: mainList.emoji!, index: insertedIndex)
        }

    }
    
    // MARK: - Convinience Method
    // IndexPath Update
    static func replaceIndex(at source: Int, for value: Int) {
        let currentMainList = self.mainLists[source]

        currentMainList.index = Int64(value)

        saveMainList()
    }
    
    static func saveMainList() {
        do {
            try self.context.save()
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    
}
