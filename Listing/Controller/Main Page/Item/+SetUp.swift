//
//  +SetUp.swift
//  Listing
//
//  Created by Johnny on 21/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController {
    func loadList() {
//
//        listsManager.lists = DataManager.loadAll(from: List.self).sorted {
//            $0.index < $1.index
//        }
//
//        if listsManager.lists.isEmpty {
//            listsManager.lists = [
//            List(emoji: "📆", title: "ToDo", items: [
//                Item(title: "Tap here to delete"),
//                Item(title: "Tap list title to change"),
//                ]
//                , index: 0),
//            List(emoji: "🛒", title: "Groceries", items: [
//                Item(title: "2 Tomatos"),
//                Item(title: "Chicken Breast")
//                ]
//                , index: 1)
//            ]
//
//            listsManager.updateIndexForLists()
//        }
           
        listTableViewDataUpdate()
        listsThumbnailCollectionViewDataUpdate()
    }
       
    func setUpView() {
        listTitleViewUpdate(emoji: currentSubList.emoji, title: currentSubList.title)
        /// Undo Button
        setUpUndoButtonView()
        
        /// List Thumbnail Collection View
        setUpListThumbnailCollectionView()
        
        /// Add Button
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
           
        /// Item Input Itew
        inputItemView.isHidden = true
        setUpItemInputToolbarView()
       }
        
    func setUpListThumbnailCollectionView() {
        listIndicator.frame.size.width = listsThumbnailWidth
         
        listsThumbnailCollectionViewLayout.itemSize = CGSize(width: listsThumbnailWidth, height: listsThumbnailWidth)
        listsThumbnailCollectionViewLayout.minimumLineSpacing = 5
         
        listsThumbnailCollectionViewLayout.sectionInset = UIEdgeInsets(
                     top: 0,
                     left: 0,
                     bottom: 0,
                     right: listsThumbnailCollectionView.frame.size.width-(listsThumbnailWidth*2)-listsThumbnailCollectionViewLayout.minimumLineSpacing)
         
         listsThumbnailCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func setUpUndoButtonView() {
        undoViewPresented(false)
        undoButton.layer.cornerRadius = 10
        undoButton.layer.borderWidth = 0.7
        undoButton.layer.borderColor = UIColor.init(named: "Destructive")?.cgColor
        undoButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        view.bringSubviewToFront(undoButton)
    }
    
    func setUpItemInputToolbarView() {
        inputItemTextView.inputAccessoryView = inputItemToolbar
        
        inputItemToolbar.frame.size.width = UIScreen.main.bounds.width
        inputItemToolbar.frame.size.height = 45
        
        toolbarAddButton.layer.cornerRadius = toolbarAddButton.frame.size.height / 2
        toolbarAddButton.isHidden = true
    }
    
}
