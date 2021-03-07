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
    var currentSubList: SubList? = nil
    
    private var items: [Item] = []
    
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
    
    private func loadCoreDataItems() -> (list: [Item], error: Error?) {
        guard let currentSubList = self.currentSubList else {
            // FIXME: Error Fixation
            return ([], nil)
        }
        
        return (currentSubList.itemsArray, nil)
        
    }
    
    func addItem(title: String, from pos: Direction) {
        guard let currentSubList = currentSubList else {
            return
        }
        
        switch pos {
        case .top:
            self.insertItem(title, at: 0)
        case .bottom:
            Item.create(title: title, index: items.count, ofSubList: currentSubList)
        }
    }
    
    func setItemCompletion(at index: Int, _ value: Bool) {
        items[index].updateComplete(with: value)
    }
    
    func deleteItem(at index: Int) {
        guard let currentSubList = currentSubList else {
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
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int) {
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
    }
    
    // MARK: - CONVENIENCE
    
    private func insertItem(_ title: String, at insertedIndex: Int) {
        guard let currentSubList = currentSubList else {
            return
        }
        
        if insertedIndex == items.count {
            addItem(title: title, from: .bottom)
        }
        
        else {
            for i in stride(from: items.count-1, through: 0, by: -1) {
            if items[i].index >= insertedIndex {
                items[i].updateIndex(with: i+1)
                }
            }
            
            Item.create(title: title, index: insertedIndex, ofSubList: currentSubList)
        }
    }
    
    
    private func convertToSubList(_ idString: String) -> SubList? {
        
        guard let objectIDURL = URL(string: idString) else {
            print("ConverToMasterList - Unable to convert to URL: \(idString)")
            return nil
        }
        
        guard let coordinatoor = PersistenceService.context.persistentStoreCoordinator else {
            print("ConvertToMasterList - Unable to find coordinator in context")
            return nil
        }

        guard let managedObjectID = coordinatoor.managedObjectID(forURIRepresentation: objectIDURL) else {
            print("ConvertToMasterList - Unable to find objectID: \(idString)")
            return nil
        }
       
        let subList = PersistenceService.context.object(with: managedObjectID) as? SubList
        
        return subList
    }
    
}
