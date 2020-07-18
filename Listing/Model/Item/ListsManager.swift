//
//  ListsManager.swift
//  Listing
//
//  Created by Johnny on 17/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class ListsManager {
    
    var lists: [List] = []
    
    func addList(_ list: List) {
        lists.append(list)
        lists[lists.count-1].saveList()
    }
    
}
