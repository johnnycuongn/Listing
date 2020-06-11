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
        Item(title: "Finish planing requirement"),
        Item(title: "Architecture Prerequisites")
    ]
    
    var listCount: Int {
        return itemsInList.count
    }
    
    var sampleData: [Item] = {
        return [
            Item(title: "Finish planing requirement"),
            Item(title: "Architecture Prerequisites")
        ]
    }()
    
    func itemAtIndex(_ index: Int) -> Item {
        return itemsInList[index]
    }
    
    func addItem(_ item: Item) {
        itemsInList.append(item)
    }

    
}
