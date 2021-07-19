//
//  MasterListPageViewModel.swift
//  Listing
//
//  Created by Johnny on 3/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol MasterListPageViewModel {
    
    var masterList: Observable<[DomainMasterList]> { get }
    var masterListCount: Int { get }
    
    func loadMasterList()
    
    func addMasterList(title: String)
    func moveMasterList(from startIndex: Int, to endIndex: Int)
    func removeMasterList(at index: Int)
}

class DefaultMasterListPageViewModel: MasterListPageViewModel {
    
    var masterList: Observable<[DomainMasterList]> = Observable([])
    var masterListCount: Int {
        return masterList.value.count
    }
    
    private var useCase: MasterListUseCase
    
    init(useCase: MasterListUseCase = DefaultMasterListUseCase()) {
        self.useCase = useCase
    }
    
    func loadMasterList() {
        useCase.loadMasterList { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let domainMasterList):
                strongSelf.masterList.value = domainMasterList
            case .failure(let error):
                strongSelf.handleError(error)
            }
            
        }
    }
    
    func addMasterList(title: String) {
        useCase.addMasterList(title: title) { [weak self] success, error in
            guard success, error == nil else {
                return
            }
            
            self?.loadMasterList()
        }
        
        
    }
    
    func moveMasterList(from startIndex: Int, to endIndex: Int) {
        useCase.moveMasterList(from: startIndex, to: endIndex) { [weak self] success, error in
            guard success, error == nil else {
                return
            }
            
            self?.loadMasterList()
        }
    }
    
    func removeMasterList(at index: Int) {
        useCase.deleteMasterList(at: index){ [weak self] success, error in
            guard success, error == nil else {
                return
            }
            
            self?.loadMasterList()
        }
    }
    
    
    // MARK: HELPER
    private func handleError(_ error: Error) {
        print("!!MasterListPage Error: \(error.localizedDescription)")
    }
    
    
}
