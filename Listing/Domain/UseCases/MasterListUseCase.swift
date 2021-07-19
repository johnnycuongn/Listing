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
    
    func addMasterList(title: String, completion: @escaping (Bool, Error?) -> Void)
    func deleteMasterList(at pos: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func moveMasterList(from startPos: Int, to endPos: Int, completion: @escaping (Bool, Error?) -> Void)
    
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
    
    func addMasterList(title: String, completion: @escaping (Bool, Error?) -> Void) {
        
        repository.addMasterList(title: title, emoji: nil) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            self?.loadMasterList { [weak self] (result) in
                switch result {
                case .success(let domainMasterList):
                    let addedList = domainMasterList[domainMasterList.count-1]
        
                    // FIXME: Data Module should not be in code of domain
                    self?.sublistRepository = SubListCoreDataRepository(masterListID: addedList.storageID)
                    
                    guard let sublistRepository = self?.sublistRepository else {
                        // Error Handling
                        return
                    }
                    
                    sublistRepository.addSubList(title: "Untitled", emoji: "📄")
                    { [weak self] success, error in
                        guard success, error == nil else {
                            completion(false, error)
                            return
                        }
                        
                        completion(true, nil)
                        
                    }
                case .failure(let error):
                    completion(false, error)
                }
            }
            
        }
        
    }
    
    func deleteMasterList(at pos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.deleteMasterList(at: pos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    func moveMasterList(from startPos: Int, to endPos: Int, completion: @escaping (Bool, Error?) -> Void) {
        repository.moveMasterList(from: startPos, to: endPos) { [weak self] success, error in
            guard success, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    
    
}
