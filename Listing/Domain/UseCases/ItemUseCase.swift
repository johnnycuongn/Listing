//
//  ItemUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol ItemUseCase {
    
    func loadItem(completion: @escaping (Result<[DomainItem], Error>) -> Void)
    
    func addItem(title: String, from addedPos: Direction)
    
    func completeItem(at position: Int)
    func uncompleteItem(at postion: Int)
    
    func deleteItem(at pos: Int)
    
    func moveItem(from startPos: Int, to endPos: Int)
}

class DefaultItemUseCase: ItemUseCase {
    
    private var defaultAddPostion: Direction = .top
    
    private var repository: ItemRepository
    
    init(subListID: String) {
        repository = ItemCoreDataRepository(subListID: subListID)
    }
    
    func loadItem(completion: @escaping (Result<[DomainItem], Error>) -> Void) {
        repository.loadItem { (result) in
            switch result {
            case .success(let domainItems):
                completion(.success(domainItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addItem(title: String, from addedPos: Direction = .top) {
        repository.addItem(title: title, from: addedPos)
    }
    
    func completeItem(at position: Int) {
        repository.setItemCompletion(at: position, true)
    }
    
    func uncompleteItem(at position: Int) {
        repository.setItemCompletion(at: position, false)
    }
    
    func deleteItem(at pos: Int) {
        repository.deleteItem(at: pos)
    }
    
    func moveItem(from startPos: Int, to endPos: Int) {
        repository.moveItem(from: startPos, to: endPos)
    }
    
    
}
