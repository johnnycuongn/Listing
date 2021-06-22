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
        setSubListView(emoji: currentSubList.emoji, title: currentSubList.title)
        
        // List Thumbnail Collection View
        setUpListThumbnailCollectionView()
           
        /// Item Input Itew
        
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
        
        inputItemToolbar.frame = CGRect(x: 0,
                                        y: UIScreen.main.bounds.height,
                                        width: UIScreen.main.bounds.width,
                                        height: 45)
        
        inputItemToolbar.backgroundColor = view.backgroundColor
        
        toolbarAddButton.layer.cornerRadius = 7
        toolbarAddButton.isHidden = false
        toolbarAddButton.backgroundColor = AssetsColor.addSub
    }
    
}

