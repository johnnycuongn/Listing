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
    func loadMasterList()
    
    
}

class DefaultMasterListPageViewModel: MasterListPageViewModel {
    
    var masterList: Observable<[DomainMasterList]> = Observable([])
    
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
    
    
    
    
    private func handleError(_ error: Error) {
        print("!!MasterListPage Error: \(error.localizedDescription)")
    }
    
    
}
