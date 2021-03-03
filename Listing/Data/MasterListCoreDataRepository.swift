//
//  MasterListStorage.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation
import CoreData

final class MasterListCoreDataRepository: MasterListRepository {
    
    private var coreDataStorage: CoreDataStorage
    private lazy var context =
//        coreDataStorage.context
        PersistenceService.context
    
    private var mainLists: [MainList] {
        get {
            return loadCoreDataMasterList().list
        }
    }
    
    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = storage
    }
    
    // MARK: LOAD
    func loadMasterList(completion: @escaping (Result<[DomainMasterList], Error>) -> Void) {
        
        let masterListLoadResult = loadCoreDataMasterList()
        
        guard masterListLoadResult.error == nil else {
            completion(.failure(masterListLoadResult.error!))
            return
        }
        
        
        let domainMasterList = masterListLoadResult.list.map { $0.toDomain()}
        completion(.success(domainMasterList))
    }
    
    func loadCoreDataMasterList() -> (list: [MainList], error: Error?) {
        var tempMainLists = [MainList]()
        var coredataError: Error?
        
        do {
            let request = MainList.fetchRequest() as NSFetchRequest<MainList>
            request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
                   
            tempMainLists = try context.fetch(request)
            
        } catch {
            coredataError = error
        }
        
        return (tempMainLists, coredataError)
    }
    
    
    // MARK: ADD
    func addMasterList(title: String, emoji: String?) {
        if emoji != nil {
            MainList.create(title: title, emoji: emoji!, index: mainLists.count)
        } else {
            MainList.create(title: title, index: mainLists.count)
        }
    }
    
    // MARK: DELETE
    
    func deleteMasterList(at index: Int) {
        // Identify removed Main List
        let removedMainList = self.mainLists[index]
        // Update index for others
        if mainLists.count > 1 {
         for i in 0...mainLists.count - 1 {
            if mainLists[i].index > index {
                mainLists[i].updateIndex(with: i-1)
                }
            }
        }
        // Delete from database
        self.context.delete(removedMainList)

        saveMainList()
    }
    
    func moveMasterList(from startIndex: Int, to endIndex: Int) {
        let movedMainList = mainLists[startIndex]
        
        // When move up frop bottom -> top
        if endIndex > startIndex {
            for i in startIndex+1...endIndex {
                if mainLists[i].index <= endIndex {
                    mainLists[i].updateIndex(with: i-1)
                }
            }
        }
        
        // When move down from top -> bottm
        else if endIndex < startIndex {
            for i in stride(from: startIndex-1, through: endIndex, by: -1) {
                if mainLists[i].index >= endIndex {
                    mainLists[i].updateIndex(with: i+1)
                }
            }
        }
        
        movedMainList.updateIndex(with: endIndex)
        PersistenceService.saveContext()
    }
    
    private func saveMainList() {
        do {
            try self.context.save()
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    
}
