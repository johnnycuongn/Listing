//
//  ListManager.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class ListManager {
    
    private var itemsInList: [Item] = [
        Item(title: "Tap to Delete")
    ]
    
    var listCount: Int {
        return itemsInList.count
    }
    
    func itemAtIndex(_ index: Int) -> Item {
        return itemsInList[index]
    }
    
    func addItem(_ item: Item) {
        itemsInList.append(item)
    }
    
    func addItemAtFirst(_ item: Item) {
        itemsInList.insert(item, at: 0)
    }
    
    func replaceItem(with item: Item,at index: Int) {
        itemsInList[index] = item
    }
    
    func deleteItem(at index: Int) {
        itemsInList.remove(at: index)
    }
    
    func moveItem(_ item: Item, from startIndex: Int, to endIndex: Int) {
        deleteItem(at: startIndex)
        itemsInList.insert(item, at: endIndex)
    }

}
