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
    var items: Observable<[DomainItem]> { get }
    
    func loadItems(of subListID: String)
    func addItem(title: String)
    func completeItem(at pos: Int)
    func uncompleteItem(at pos: Int)
    
    func deleteItem(at pos: Int)
    func moveItem(from startPos: Int, to endPos: Int)
}

protocol ItemPageViewModel: SubListViewModel, ItemListViewModel {
    func initiateLoadPage()
}

class DefaultItemPageViewModel: ItemPageViewModel {
    
    var items: Observable<[DomainItem]> = Observable([])
    var subLists: Observable<[DomainSubList]> = Observable([])
    
    private var subListUseCase: SubListUseCase
    private var itemUseCase: ItemUseCase = DefaultItemUseCase(subListID: "")
    
    init(masterListID: String) {
        self.subListUseCase = DefaultSubListUseCase(masterListID: masterListID)
    }
    
    // MARK: - ALL
    
    /// Load SubList ands correspondent Items for 1 SubList
    func initiateLoadPage() {
        loadSubLists()
        loadItems(of: subLists.value[0].storageID)
    }
    
    // MARK: - SUBLIST
    func loadSubLists() {
        subListUseCase.loadSubList { [weak self] (result) in
            switch result {
            case .success(let sublists):
                self?.subLists.value = sublists
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func addSubList(title: String, emoji: String) {
        subListUseCase.addSubList(title: title, emoji: emoji)
    }
    
    // MARK: - ITEM
    
    func loadItems(of subListID: String) {
        itemUseCase = DefaultItemUseCase(subListID: subListID)
        
        itemUseCase.loadItem { [weak self] (result) in
            switch result {
            case .success(let items):
                self?.items.value = items
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func addItem(title: String) {
        itemUseCase.addItem(title: title, from: .top)
    }
    
    func completeItem(at pos: Int) {
        itemUseCase.completeItem(at: pos)
    }
    
    func uncompleteItem(at pos: Int) {
        itemUseCase.uncompleteItem(at: pos)
    }
    
    func deleteItem(at pos: Int) {
        itemUseCase.deleteItem(at: pos)
    }
    
    func moveItem(from startPos: Int, to endPos: Int) {
        itemUseCase.moveItem(from: startPos, to: endPos)
    }
    
    
    private func handleError(_ error: Error) {
        print("ItemPageViewModel: \(error.localizedDescription)")
    }
    
}
