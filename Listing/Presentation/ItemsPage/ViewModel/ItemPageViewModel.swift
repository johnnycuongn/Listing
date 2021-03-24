//
//  SubListViewModel.swift
//  Listing
//
//  Created by Johnny on 7/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

protocol SubListViewModel {
    var subLists: Observable<[DomainSubList]> { get }
    
    func loadSubLists()
    func addSubList(title: String, emoji: String)
    
    func deleteSubList(at pos: Int)
    func moveSubList(from startPos: Int, to endPos: Int)
    
    func updateSublist(title: String, at position: Int)
    func updateSublist(emoji: String, at position: Int)
}

protocol ItemListViewModel {
    var items: Observable<[DomainItem]> { get }
    
    func loadItems(atList subListIndex: Int)
    func addItem(title: String)
    func completeItem(at pos: Int)
    func uncompleteItem(at pos: Int)
    
    func insertItem(_ title: String, at pos: Int)
    
    func deleteItem(at pos: Int)
    func moveItem(from startPos: Int, to endPos: Int)
    
    func canHandle(_ session: UIDropSession) -> Bool
    func dragItems(for indexPath: IndexPath) -> [UIDragItem]
}

protocol ItemPageViewModel: SubListViewModel, ItemListViewModel {
    var subListCurrentIndex: Int { get set }
    
    func initiateLoadPage()
}

class DefaultItemPageViewModel: ItemPageViewModel {
    
    var subListCurrentIndex: Int = 0 {
        didSet {
            loadItems(atList: subListCurrentIndex)
        }
    }
    
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
        loadItems(atList: subListCurrentIndex)
    }
    
    // MARK: - SUBLIST
    func loadSubLists() {
        subListUseCase.loadSubList { [weak self] (result) in
            switch result {
            case .success(let loadedsSublists):
                if loadedsSublists.count == 0 {
                    self?.addSubList(title: "Untitled", emoji: "📄")
                }
                self?.subLists.value = loadedsSublists
                
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func addSubList(title: String, emoji: String) {
        subListUseCase.addSubList(title: title, emoji: emoji)
    }
    
    func deleteSubList(at pos: Int) {
        subListUseCase.deleteSubList(at: pos)
    }
    
    func moveSubList(from startPos: Int, to endPos: Int) {
        subListUseCase.moveSubList(from: startPos, to: endPos)
    }
    
    func updateSublist(title: String, at position: Int) {
        subListUseCase.updateSubList(title: title, at: position)
        
        loadSubLists()
    }
    
    func updateSublist(emoji: String, at position: Int) {
        subListUseCase.updateSubList(emoji: emoji, at: position)
        
        loadSubLists()
    }
    
    // MARK: - ITEM
    
    func loadItems(atList subListIndex: Int) {
        if subLists.value.count == 0 {
            addSubList(title: "Untitled", emoji: "📑")
        }
        let currentSubListID = subLists.value[subListIndex].storageID
        
        itemUseCase = DefaultItemUseCase(subListID: currentSubListID)
        
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
        
        loadItems(atList: subListCurrentIndex)
    }
    
    func completeItem(at pos: Int) {
        itemUseCase.completeItem(at: pos)
        
        loadItems(atList: subListCurrentIndex)
    }
    
    func uncompleteItem(at pos: Int) {
        itemUseCase.uncompleteItem(at: pos)
        
        loadItems(atList: subListCurrentIndex)
    }
    
    func insertItem(_ title: String, at pos: Int) {
        itemUseCase.insertItem(title: title, at: pos)
        
        loadItems(atList: subListCurrentIndex)
    }
    
    
    func deleteItem(at pos: Int) {
        itemUseCase.deleteItem(at: pos)
        
        loadItems(atList: subListCurrentIndex)
    }
    
    func moveItem(from startPos: Int, to endPos: Int) {
        itemUseCase.moveItem(from: startPos, to: endPos)
        
        loadItems(atList: subListCurrentIndex)
    }
    
    func canHandle(_ session: UIDropSession) -> Bool {
           return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let placeItem = items.value[indexPath.row].title

        let data = placeItem.data(using: .utf8)
           let itemProvider = NSItemProvider()
           
           itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
               completion(data, nil)
               return nil
           }

           return [
               UIDragItem(itemProvider: itemProvider)
           ]
    }
    
    
    private func handleError(_ error: Error) {
        print("ItemPageViewModel: \(error.localizedDescription)")
    }
    
}
