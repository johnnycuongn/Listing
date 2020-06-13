//
//  Item.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

struct Item: Codable {
    var title: String
    
    var index: Int
    var itemIdentifier: UUID
    
//    init(title: String, index: Int, itemIdentifier: UUID) {
//        self.title = title
//        self.index = index
//        self.itemIdentifier = itemIdentifier
//    }
    
    mutating func changeIndex(by number: Int) {
        self.index += number
    }

    func save() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func delete() {
        DataManager.delete(from: itemIdentifier.uuidString)
    }
    
}
