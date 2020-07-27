//
//  List.swift
//  Listing
//
//  Created by Johnny on 17/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

enum Direction {
    case top
    case bottom
}

class List: Codable {
    
    var emoji: String {
        didSet {
            saveList() }
    }
    var title: String {
        didSet {
            DataManager.delete(from: "\(oldValue)")
            DataManager.save(self, with: "\(title)") }
    }
    
    var items: [Item] {
        didSet {
            saveList() }
    }
    
    var index: Int {
        didSet {
            saveList() }
    }
    
    init(emoji: String, title: String, items: [Item], index: Int) {
        self.emoji = emoji
        self.title = title
        self.items = items
        self.index = index
    }

    // MARK: Function
    
    func addItem(_ item: Item, from position: Direction) {
        if position == .top {
            items.insert(item, at: 0) }
        else {
            items.append(item) }
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
    }
    
    func moveItem(from startIndex: Int, to endIndex: Int) {
        guard startIndex != endIndex else { return }
        
        let movedItem = items.remove(at: startIndex)
        items.insert(movedItem, at: endIndex)
    }
    
    // MARK: Save List
    
    func saveList() {
        DataManager.save(self, with: "\(title)")
    }

    func deleteList() {
        DataManager.delete(from: "\(title)")
    }

}
