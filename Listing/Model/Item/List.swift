//
//  List.swift
//  Listing
//
//  Created by Johnny on 17/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class List: Codable {
    
    var emoji: String {
        didSet {
            saveList()
        }
    }
    var title: String {
        didSet {
            DataManager.delete(from: "\(oldValue)")
            DataManager.save(self, with: "\(title)")
        }
    }
    
    var items: [Item] {
        didSet {
            saveList()
        }
    }
    
    init(emoji: String, title: String, items: [Item]) {
        self.emoji = emoji
        self.title = title
        self.items = items
    }
    
    func saveList() {
        DataManager.save(self, with: "\(title)")
    }

    func deleteList() {
        DataManager.save(self, with: "\(title)")
    }
    
    func addItemAtTop(_ item: Item) {
        items.insert(item, at: 0)
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int) {
        guard startIndex != endIndex else { return }
        
        var movedItem = items.remove(at: startIndex)
        items.insert(movedItem, at: endIndex)
        
    }

}
