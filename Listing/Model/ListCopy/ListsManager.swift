////
////  ListsManager.swift
////  Listing
////
////  Created by Johnny on 17/7/20.
////  Copyright © 2020 Johnny. All rights reserved.
////
//
//import Foundation
//
//class ListsManager {
//
//    var subListsArray: [List] = [] {
//        didSet {
//            updateIndexForLists() }
//    }
//
//    func addSubList(_ list: List) {
//        subListsArray.append(list)
//        subListsArray[subListsArray.count-1].saveList()
//    }
//
//    func deleteSubList(at index: Int) {
//        subListsArray.remove(at: index).deleteList()
//    }
//
//    func moveSubList(from startIndex: Int, to endIndex: Int) {
//        let movedList = subListsArray.remove(at: startIndex)
//        subListsArray.insert(movedList, at: endIndex)
//    }
//
//    func updateIndexForLists() {
//        if subListsArray.count > 0 {
//            for i in 0..<subListsArray.count {
//                subListsArray[i].index = i }
//        }
//    }
//
////
////       func itemAtIndex(_ index: Int) -> Item {
////           return itemsInList[index]
////       }
////
////       func addItemAtTop(_ item: Item) {
////           if listCount == 1 {
////               itemsInList[0].changeIndex(by: 1)
////           } else if listCount > 1 {
////               for i in 0...listCount-1 {
////                   itemsInList[i].changeIndex(by: 1)
////               }
////           }
////           item.save()
////           itemsInList.insert(item, at: 0)
////       }
////
////       func replaceItem(with item: Item,at index: Int) {
////           itemsInList[index] = item
////       }
////
////       func deleteItem(at index: Int) {
////           if listCount > 1 {
////               for i in 0...listCount - 1 {
////                   if itemsInList[i].index > index {
////                       itemsInList[i].changeIndex(by: -1)
////                   }
////               }
////           }
////           itemsInList[index].delete()
////           itemsInList.remove(at: index)
////       }
////
////       func moveItem(from startIndex: Int, to endIndex: Int) {
////           guard startIndex != endIndex else { return }
////
////           var item = itemsInList[startIndex]
////           item.index = endIndex
////
////           itemsInList.remove(at: startIndex)
////
////           for i in 0...listCount - 1 {
////               if endIndex < startIndex {
////                   if itemsInList[i].index >= endIndex {
////                       itemsInList[i].changeIndex(by: 1)
////                   }
////               } else {
////                   if itemsInList[i].index <= endIndex {
////                       itemsInList[i].changeIndex(by: -1)
////                   }
////               }
////           }
////           itemsInList.insert(item, at: endIndex)
////       }
//
//
//}
