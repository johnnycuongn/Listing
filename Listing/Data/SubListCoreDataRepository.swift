//
//  SubListStorage.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation
import CoreData

final class SubListCoreDataRepository: SubListRepository {
    
    private var coreDataStorage: CoreDataStorage
    lazy var context =
        PersistenceService.context
    
    var masterListID: String
    var currentMasterList: MainListEntity? = nil
    
    private var subLists: [SubListEntity] = []
    
    init(masterListID: String, storage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = storage
        
        self.masterListID = masterListID
        
        guard let masterList = convertToMasterList(masterListID) else {
            return
        }
        self.currentMasterList = masterList
    }
    
    // MARK: - LOAD
    func loadSubList(completion: @escaping (Result<[DomainSubList], Error>) -> Void) {
        let subListLoadResult = loadCoreDataSubList()
        
        guard subListLoadResult.error == nil else {
            completion(.failure(subListLoadResult.error!))
            return
        }
        
        self.subLists = subListLoadResult.list
        let domainSubLists = subLists.map { $0.toDomain() }
        
        completion(.success(domainSubLists))
        
    }
    
    private func loadCoreDataSubList() -> (list: [SubListEntity], error: Error?) {
        guard let currentMasterList = self.currentMasterList else {
            // FIXME: Error Fixation
            return ([], nil)
        }
        
        return (currentMasterList.subListsArray, nil)
        
    }
    
    // MARK: - ADD
    
    func addSubList(title: String, emoji: String) {
        guard let currentMasterList = self.currentMasterList else {
            return
        }
        
        SubListEntity.create(title: title, emoji: emoji, index: subLists.count, ofMainList: currentMasterList)
    }
    
    // MARK: - UPDATE
    func updateSubList(title: String, at index: Int) {
        subLists[index].title = title
        
        PersistenceService.saveContext()
        
    }
    
    func updateSubList(emoji: String, at index: Int) {
        subLists[index].emoji = emoji
        
        PersistenceService.saveContext()
    }
    
    // MARK: - DELETE
    
    func deleteSubList(at index: Int) {
        // Identify removed Main List
        let removedSubList = self.subLists[index]
        // Update index for others
        if subLists.count > 1 {
            for i in 0...subLists.count - 1 {
            if subLists[i].index > index {
        //                   replaceIndex(at: i, for: i-1)
                subLists[i].updateIndex(with: i-1)
                }
            }
        }
        // Delete from database
        guard let currentMasterList = self.currentMasterList else {
            return
        }
        currentMasterList.removeFromSubLists(removedSubList)
        PersistenceService.context.delete(removedSubList)
        
        PersistenceService.saveContext()
    }
    
    // MARK: - MOVE
    
    func moveSubList(from startIndex: Int, to endIndex: Int) {
        let movedSubList = subLists[startIndex]
        
        // When move up frop bottom -> top
        if endIndex > startIndex {
            for i in startIndex+1...endIndex {
                if subLists[i].index <= endIndex {
                    subLists[i].updateIndex(with: i-1)
                }
            }
        }
        
        // When move down from top -> bottm
        else if endIndex < startIndex {
            for i in stride(from: startIndex-1, through: endIndex, by: -1) {
            if subLists[i].index >= endIndex {
                    subLists[i].updateIndex(with: i+1)
                }
            }
        }
        
        movedSubList.updateIndex(with: endIndex)
        PersistenceService.saveContext()
    }
    
    // MARK: - CONVENIENCE
    
    private func convertToMasterList(_ idString: String) -> MainListEntity? {
        
        guard let objectIDURL = URL(string: idString) else {
            print("SubListCoreDataRepository: ConverToMasterList - Unable to convert to URL: \(idString)")
            return nil
        }
        
        guard let coordinatoor = PersistenceService.context.persistentStoreCoordinator else {
            print("SubListCoreDataRepository: ConvertToMasterList - Unable to find coordinator in context")
            return nil
        }

        guard let managedObjectID = coordinatoor.managedObjectID(forURIRepresentation: objectIDURL) else {
            print("SubListCoreDataRepository: ConvertToMasterList - Unable to find objectID: \(idString)")
            return nil
        }
       
        let masterList = PersistenceService.context.object(with: managedObjectID) as? MainListEntity
        
        return masterList
    }
    
}
