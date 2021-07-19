//
//  SubListUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol SubListUseCase {
    
    func loadSubList(completion: @escaping (Result<[DomainSubList], Error>) -> Void)
    
    func addSubList(title: String, emoji: String, completion: @escaping (Bool, Error?) -> Void)
    func deleteSubList(at pos: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func moveSubList(from startPos: Int, to endPos: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func updateSubList(title: String, at position: Int, completion: @escaping (Bool, Error?) -> Void)
    func updateSubList(emoji: String, at position: Int, completion: @escaping (Bool, Error?) -> Void)
}

class DefaultSubListUseCase: SubListUseCase {
    
    private var repository: SubListRepository
    
    init(masterListID: String) {
        self.repository = SubListCoreDataRepository(masterListID: masterListID)
    }
    
    func loadSubList(completion: @escaping (Result<[DomainSubList], Error>) -> Void) {
        
        repository.loadSubList { (result) in
            switch result {
            case .success(let domainSubLists):
                completion(.success(domainSubLists))
            case .failure(let error):
                completion(.failure(error ))
            }
        }
    }
    
    func addSubList(title: String, emoji: String, completion: @escaping (Bool, Error?) -> Void) {
        repository.addSubList(title: title, emoji: emoji) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    func deleteSubList(at pos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.deleteSubList(at: pos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    func moveSubList(from startPos: Int, to endPos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.moveSubList(from: startPos, to: endPos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    func updateSubList(title: String, at position: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.updateSubList(title: title, at: position) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    func updateSubList(emoji: String, at position: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.updateSubList(emoji: emoji, at: position) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
}
