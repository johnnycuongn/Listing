//
//  ItemCoreDataRepository.swift
//  Listing
//
//  Created by Johnny on 7/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

class ItemCoreDataRepository: ItemRepository {
    
    private var coreDataStorage: CoreDataStorage
    lazy var context =
        PersistenceService.context
    
    var subListID: String
    var currentSubList: SubListEntity? = nil
    
    private var items: [ItemEntity] = []
    
    init(subListID: String, storage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = storage
        
        self.subListID = subListID
        
        guard let subList = convertToSubList(subListID) else {
            return
        }
        self.currentSubList = subList
    }
    
    func loadItem(completion: @escaping (Result<[DomainItem], Error>) -> Void) {
        let itemLoadResult = loadCoreDataItems()
        
        guard itemLoadResult.error == nil else {
            completion(.failure(itemLoadResult.error!))
            return
        }
        
        self.items = itemLoadResult.list
        let domainItems = items.map { $0.toDomain() }
        
        completion(.success(domainItems))
    }
    
    private func loadCoreDataItems() -> (list: [ItemEntity], error: Error?) {
        guard let currentSubList = self.currentSubList else {
            // FIXME: Error Fixation
            return ([], nil)
        }
        
        return (currentSubList.itemsArray, nil)
        
    }
    
    func addItem(title: String, from pos: Direction, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentSubList = currentSubList else {
            completion(false, nil)
            return
        }
        
        switch pos {
        case .top:
            self.insertItem(title: title, at: 0) { [weak self] success, error in
                guard success, error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
        case .bottom:
            ItemEntity.create(title: title, index: items.count, ofSubList: currentSubList)
            completion(true, nil)
        }
    }
    
    func setItemCompletion(at index: Int, _ value: Bool, completion: @escaping (Bool, Error?) -> Void) {
        items[index].updateComplete(with: value)
    }
    
    func deleteItem(at index: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentSubList = currentSubList else {
            completion(false, nil)
            return
        }
        
        let removedItem = self.items[index]
                // Update index for others
        if items.count > 1 {
            for i in 0...items.count - 1 {
                if items[i].index > index {
        //                     replaceIndex(at: i, for: i-1)
                items[i].updateIndex(with: i-1)
                }
            }
        }
        currentSubList.removeFromItems(removedItem)
        // Delete from database
        PersistenceService.context.delete(removedItem)

        PersistenceService.saveContext()
        completion(true, nil)
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int, completion: @escaping (Bool, Error?) -> Void) {
        let movedItem = self.items[startIndex]
        
        // When move up frop bottom -> top
        if endIndex > startIndex {
            for i in startIndex+1...endIndex {
                if items[i].index <= endIndex {
                    items[i].updateIndex(with: i-1)
                }
            }
        }
        
        // When move down from top -> bottm
        else if endIndex < startIndex {
            for i in stride(from: startIndex-1, through: endIndex, by: -1) {
            if items[i].index >= endIndex {
                    items[i].updateIndex(with: i+1)
                }
            }
        }
        
        movedItem.updateIndex(with: endIndex)
        PersistenceService.saveContext()
        
        completion(true, nil)
    }
    
    // MARK: - CONVENIENCE
    
    func insertItem(title: String, at insertedPos: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentSubList = currentSubList else {
            completion(false, nil)
            return
        }
        
        if insertedPos == items.count {
            addItem(title: title, from: .bottom) { [weak self] success, error in
                guard success, error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
        }
        
        else {
            for i in stride(from: items.count-1, through: 0, by: -1) {
            if items[i].index >= insertedPos {
                items[i].updateIndex(with: i+1)
                }
            }
            
            ItemEntity.create(title: title, index: insertedPos, ofSubList: currentSubList)
            completion(true, nil)
        }
    }
    
    
    private func convertToSubList(_ idString: String) -> SubListEntity? {
        
        guard let objectIDURL = URL(string: idString) else {
            print("ItemCoreDataRepository: ConverToSubList - Unable to convert to URL: \(idString)")
            return nil
        }
        
        guard let coordinatoor = PersistenceService.context.persistentStoreCoordinator else {
            print("ItemCoreDataRepository: ConverToSubList - Unable to find coordinator in context")
            return nil
        }

        guard let managedObjectID = coordinatoor.managedObjectID(forURIRepresentation: objectIDURL) else {
            print("ItemCoreDataRepository: ConverToSubList - Unable to find objectID: \(idString)")
            return nil
        }
       
        let subList = PersistenceService.context.object(with: managedObjectID) as? SubListEntity
        
        return subList
    }
    
}
