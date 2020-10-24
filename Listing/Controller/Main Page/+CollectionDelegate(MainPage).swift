//
//  + CollectionDelegate(MainPage).swift
//  Listing
//
//  Created by Johnny on 10/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit


extension MainPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < MainListManager.mainLists.count {
            print("MainList Selected: \(MainListManager.mainLists[indexPath.row].title)")
        } else if indexPath.row == MainListManager.mainLists.count {
            addNewMainList()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        MainListManager.move(from: sourceIndexPath, to: destinationIndexPath)
    }

}

extension MainPageViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            
            action.fulfill(with: .delete)
            self.actionSheetForDelete(for: indexPath)

        }
        
        let trashImage =  UIImage(systemName: "trash")!
        deleteAction.image = trashImage
            .withTintColor(AssetsColor.destructive, renderingMode: .alwaysOriginal)
        
        deleteAction.backgroundColor = .clear

        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        options.backgroundColor = .clear
        
        return options
    }
    
    
}
