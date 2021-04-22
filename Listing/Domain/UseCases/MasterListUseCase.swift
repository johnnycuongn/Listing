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
    
    func addMasterList(title: String, completion: @escaping (Error?) -> Void)
    func deleteMasterList(at pos: Int)
    
    func moveMasterList(from startPos: Int, to endPos: Int)
    
}

class DefaultMasterListUseCase: MasterListUseCase {
    
    private var repository: MasterListRepository
    private var sublistRepository: SubListRepository?
    
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
    
    func addMasterList(title: String, completion: @escaping (Error?) -> Void) {
        
        repository.addMasterList(title: title, emoji: nil)
        
        loadMasterList { [weak self] (result) in
            switch result {
            case .success(let domainMasterList):
                let addedList = domainMasterList[domainMasterList.count-1]
    
                self?.sublistRepository = SubListCoreDataRepository(masterListID: addedList.storageID)
                
                guard let sublistRepository = self?.sublistRepository else {
                    // Error Handling
                    return
                }
                
                sublistRepository.addSubList(title: "Untitled", emoji: "📄")
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
        
    }
    
    func deleteMasterList(at pos: Int) {
        repository.deleteMasterList(at: pos)
    }
    
    func moveMasterList(from startPos: Int, to endPos: Int) {
        repository.moveMasterList(from: startPos, to: endPos)
    }
    
    
}
