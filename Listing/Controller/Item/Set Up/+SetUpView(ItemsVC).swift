//
//  +SetUpView.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController {
    
    func setUpView() {
        listTitleViewUpdate(emoji: currentSubList.emoji, title: currentSubList.title)
        
        // List Thumbnail Collection View
        setUpListThumbnailCollectionView()
        
        // Add Button
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
    
    func setUpItemInputToolbarView() {
        inputItemTextView.inputAccessoryView = inputItemToolbar
        
        inputItemToolbar.frame.size.width = UIScreen.main.bounds.width
        inputItemToolbar.frame.size.height = 45
        
        toolbarAddButton.layer.cornerRadius = toolbarAddButton.frame.size.height / 2
        toolbarAddButton.isHidden = true
    }
    
}
