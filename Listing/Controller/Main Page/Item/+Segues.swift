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
    }
    static let toListsVC = "toListViewController"
}


extension ItemsViewController {
    
    @IBAction func unwindToListViewController(segue: UIStoryboardSegue) {
        /// When an Emoji is chosen
        if segue.identifier == Segues.unwind.saveEmoji {
            let emojiPageVC = segue.source as! EmojiPageViewController
     
            guard emojiPageVC.selectedEmoji != nil else { return }
            
//            self.currentSubList.emoji = emojiPageVC.selectedEmoji!
            self.currentSubList.updateEmoji(with: emojiPageVC.selectedEmoji!)
            emojiButton.setTitle(emojiPageVC.selectedEmoji, for: .normal)
            
            listsThumbnailCollectionView.reloadData()
        }
        
        /// When a list from Lists Collection is selected
        if segue.identifier == Segues.unwind.selectedList {
            let listsVC = segue.source as! ListsViewController
            
            if let selectedIndexPath = listsVC.listsCollectionView.indexPathsForSelectedItems?.first {
                self.listIndex = selectedIndexPath.row
            } else if listsVC.hasDeleted {
                self.listIndex = 0
            }

            self.listsThumbnailCollectionView.contentOffset.x = listsThumbnailWidth*CGFloat(listIndex)+listsThumbnailCollectionViewLayout.minimumLineSpacing*CGFloat(listIndex)
            listsThumbnailCollectionViewDataUpdate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Segue to Lists View Controller
        if segue.identifier == Segues.toListsVC {
            guard let listsVC = segue.destination as? ListsViewController else  {
                fatalError()
            }
//            listsVC.currentMainList = self.listsManager
        }
    }
}
