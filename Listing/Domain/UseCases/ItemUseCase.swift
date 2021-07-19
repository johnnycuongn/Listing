//
//  ItemUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

enum Direction {
    case top
    case bottom
}

protocol ItemUseCase {
    
    func loadItem(completion: @escaping (Result<[DomainItem], Error>) -> Void)
    
    func addItem(title: String, from addedPos: Direction, completion: @escaping (Bool, Error?) -> Void)
    
    func completeItem(at position: Int, completion: @escaping (Bool, Error?) -> Void)
    func uncompleteItem(at postion: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func insertItem(title: String, at insertedPos: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func deleteItem(at pos: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func moveItem(from startPos: Int, to endPos: Int, completion: @escaping (Bool, Error?) -> Void)
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
    
    func addItem(title: String, from addedPos: Direction = .top, completion: @escaping (Bool, Error?) -> Void) {
        repository.addItem(title: title, from: addedPos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func completeItem(at position: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.setItemCompletion(at: position, true) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func uncompleteItem(at position: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.setItemCompletion(at: position, false) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func insertItem(title: String, at insertedPos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.insertItem(title: title, at: insertedPos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func deleteItem(at pos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.deleteItem(at: pos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func moveItem(from startPos: Int, to endPos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.moveItem(from: startPos, to: endPos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    
}
