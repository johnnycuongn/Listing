////
////  List.swift
////  Listing
////
////  Created by Johnny on 17/7/20.
////  Copyright © 2020 Johnny. All rights reserved.
////
//
//import Foundation
//
//enum Direction {
//    case top
//    case bottom
//}
//
//class List: Codable {
//    
//    var emoji: String {
//        didSet {
//            saveList() }
//    }
//    var title: String {
//        didSet {
//            DataManager.delete(from: "\(oldValue)")
//            DataManager.save(self, with: "\(title)") }
//    }
//    
//    var itemsArray: [Item] {
//        didSet {
//            saveList() }
//    }
//    
//    var index: Int {
//        didSet {
//            saveList() }
//    }
//    
//    init(emoji: String, title: String, items: [Item], index: Int) {
//        self.emoji = emoji
//        self.title = title
//        self.itemsArray = items
//        self.index = index
//    }
//
//    // MARK: Function
//    
//    func addItem(_ item: Item, from position: Direction) {
//        if position == .top {
//            itemsArray.insert(item, at: 0) }
//        else {
//            itemsArray.append(item) }
//    }
//    
//    func deleteItem(at index: Int) {
//        itemsArray.remove(at: index)
//    }
//    
//    func moveItem(from startIndex: Int, to endIndex: Int) {
//        guard startIndex != endIndex else { return }
//        
//        let movedItem = itemsArray.remove(at: startIndex)
//        itemsArray.insert(movedItem, at: endIndex)
//    }
//    
//    // MARK: Save List
//    
//    func saveList() {
//        DataManager.save(self, with: "\(title)")
//    }
//
//    func deleteList() {
//        DataManager.delete(from: "\(title)")
//    }
//
//}
