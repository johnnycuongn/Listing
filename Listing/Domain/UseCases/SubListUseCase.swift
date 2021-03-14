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
    
    func addSubList(title: String, emoji: String)
    func deleteSubList(at pos: Int)
    
    func moveSubList(from startPos: Int, to endPos: Int)
    
    func updateSubList(title: String, at position: Int)
    func updateSubList(emoji: String, at position: Int)
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
    
    func addSubList(title: String, emoji: String) {
        repository.addSubList(title: title, emoji: emoji)
    }
    
    func deleteSubList(at pos: Int) {
        repository.deleteSubList(at: pos)
    }
    
    func moveSubList(from startPos: Int, to endPos: Int) {
        repository.moveSubList(from: startPos, to: endPos)
    }
    
    func updateSubList(title: String, at position: Int) {
        repository.updateSubList(title: title, at: position)
    }
    
    func updateSubList(emoji: String, at position: Int) {
        repository.updateSubList(emoji: emoji, at: position)
    }
    
}
