//
//  ListManager.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class ListManager {
    
    var itemsInList: [Item] = [
        Item(title: "Tap to Delete", index: 0, itemIdentifier: UUID())
    ]
    
    var newList: [Item] {
        return itemsInList.sorted { (item1, item2) -> Bool in
            item1.index < item2.index
        }
    }
    
    var listCount: Int {
        return itemsInList.count
    }
    
    func itemAtIndex(_ index: Int) -> Item {
        return itemsInList[index]
    }

    func addItemAtFirst(_ item: Item) {
        if listCount == 1 {
            saveNewItem(ofIndex: 0, by: +1)
        } else if listCount > 1 {
            for i in 0...listCount-1 {
//                saveNewItem(ofIndex: i, by: +1)
                itemsInList[i].changeIndex(by: 1)
            }
        }
        item.save()
        itemsInList.insert(item, at: 0)
    }
    
    func replaceItem(with item: Item,at index: Int) {
        itemsInList[index] = item
    }
    
    func deleteItem(at index: Int) {
        if listCount > 1 {
            for i in 0...listCount - 1 {
                if itemsInList[i].index > index {
//                    saveNewItem(ofIndex: i, by: -1)
                    itemsInList[i].changeIndex(by: -1)
                }
            }
        }
        itemsInList[index].delete()
        itemsInList.remove(at: index)
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int) {
        guard startIndex != endIndex else { return }
        
        var item = itemAtIndex(startIndex)
//        var holerItem = item
//        item.delete()
//        holerItem.index = endIndex
//        let newItem = holerItem
//        newItem.save()
        item.index = endIndex
        
        deleteItem(at: startIndex)
        
        for i in 0...listCount - 1 {
            if itemsInList[i].index >= endIndex {
//                saveNewItem(ofIndex: i, by: +1)
                itemsInList[i].changeIndex(by: 1)
            }
        }
        
        itemsInList.insert(item, at: endIndex)
    }
    
    func saveNewItem(ofIndex i: Int, by value: Int) {
        let oldItem = itemsInList[i]
        var newItem = oldItem
        newItem.changeIndex(by: value)
        newItem.save()
        replaceItem(with: newItem, at: i)
        oldItem.delete()
    }

}
