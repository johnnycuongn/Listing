//
//  SubListViewModel.swift
//  Listing
//
//  Created by Johnny on 7/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol SubListViewModel {
    var subLists: Observable<[DomainSubList]> { get }
    
    func loadSubLists()
    func addSubList(title: String, emoji: String)
}

protocol ItemListViewModel {
}

protocol ItemPageViewModel: SubListViewModel {
    
}

class DefaultItemPageViewModel: ItemPageViewModel {
    
    var subLists: Observable<[DomainSubList]> = Observable([])
    
    private var useCase: SubListUseCase
    
    init(masterListID: String) {
        self.useCase = DefaultSubListUseCase(masterListID: masterListID)
    }
    
    func loadSubLists() {
        useCase.loadSubList { [weak self] (result) in
            switch result {
            case .success(let sublists):
                self?.subLists.value = sublists
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func addSubList(title: String, emoji: String) {
        useCase.addSubList(title: title, emoji: emoji)
    }
    
    
    private func handleError(_ error: Error) {
        print("ItemPageViewModel: \(error.localizedDescription)")
    }
    
}
