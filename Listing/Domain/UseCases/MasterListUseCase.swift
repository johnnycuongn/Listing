//
//  MasterListUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol MasterListUseCase {
    
    func loadMasterList(completion: @escaping (Result<[DomainMasterList], Error>) -> Void)
    
    func addMasterList(title: String)
    func deleteMasterList(at pos: Int)
    
    func moveMasterList(from startPos: Int, to endPos: Int)
    
}

class DefaultMasterListUseCase: MasterListUseCase {
    
    private var repository: MasterListRepository
    
    init(repository: MasterListRepository = MasterListCoreDataRepository()) {
        self.repository = repository
    }
    
    func loadMasterList(completion: @escaping (Result<[DomainMasterList], Error>) -> Void) {
        repository.loadMasterList { (result) in
            switch result {
            case .success(let domainMasterList):
                completion(.success(domainMasterList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addMasterList(title: String) {
        
        repository.addMasterList(title: title, emoji: nil)
        
    }
    
    func deleteMasterList(at pos: Int) {
        repository.deleteMasterList(at: pos)
    }
    
    func moveMasterList(from startPos: Int, to endPos: Int) {
        repository.moveMasterList(from: startPos, to: endPos)
    }
    
    
}
