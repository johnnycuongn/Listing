//
//  ItemsViewController+Segues.swift
//  Listing
//
//  Created by Johnny on 27/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

public enum Segues {
    enum unwind {
        static let saveEmoji = "saveEmoji"
        static let selectedList = "selectedFromListsCollectionView"
        static let saveItem = "saveItem"
    }
    static let toItemsVC = "toItemsVC"
    static let toItemInformation = "toItemInformationPage"
}


extension ItemsViewController {
    
    @IBAction func unwindToItemsViewController(segue: UIStoryboardSegue) {
        /// When an Emoji is chosen
        if segue.identifier == Segues.unwind.saveEmoji {
            let emojiPageVC = segue.source as! EmojiPageViewController
     
            guard emojiPageVC.selectedEmoji != nil else { return }
            
            self.currentSubList.updateEmoji(with: emojiPageVC.selectedEmoji!)
            emojiButton.setTitle(emojiPageVC.selectedEmoji, for: .normal)
            
            listsThumbnailCollectionView.reloadData()
        }
        
        if segue.identifier == Segues.unwind.saveItem {
            itemsTableView.reloadData()
        }
        
        /// When a list from Lists Collection is selected
//        if segue.identifier == Segues.unwind.selectedList {
//            let listsVC = segue.source as! ListsViewController
//
//            if let selectedIndexPath = listsVC.listsCollectionView.indexPathsForSelectedItems?.first {
//                self.listIndex = selectedIndexPath.row
//            } else if listsVC.hasDeleted {
//                self.listIndex = 0
//            }
//
//            self.listsThumbnailCollectionView.contentOffset.x = listsThumbnailWidth*CGFloat(listIndex)+listsThumbnailCollectionViewLayout.minimumLineSpacing*CGFloat(listIndex)
//            listsThumbnailCollectionViewDataUpdate()
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toItemInformation,
            let informationVC = segue.destination as? ItemInformationVC {
            
            guard let selectedIndexPath = itemsTableView.indexPathForSelectedRow else {
                return
            }
            
            informationVC.selectedItem = currentSubList.itemsArray[selectedIndexPath.row]
        }
    }
}
