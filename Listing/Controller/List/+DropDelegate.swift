//
//  +DropDelegate.swift
//  Listing
//
//  Created by Johnny on 19/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ListsViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
        
//        let destinationIndexPath: IndexPath
//
//        if let indexPath = coordinator.destinationIndexPath {
//            destinationIndexPath = indexPath
//        } else {
//            // Get last index path of table view.
//            let section = tableView.numberOfSections - 1
//            let row = tableView.numberOfRows(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        coordinator.session.loadObjects(ofClass: NSString.self) { items in
//            // Consume drag items.
//            let stringItems = items as! [String]
//
//            var indexPaths = [IndexPath]()
//            for (index, item) in stringItems.enumerated() {
//                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//             let movingItem = Item(title: item)
//             self.currentList.addItem(movingItem, from: .top)
//                indexPaths.append(indexPath)
//            }
//
//            tableView.insertRows(at: indexPaths, with: .automatic)
//        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first
            , let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.listsManager.moveList(from: sourceIndexPath.row, to: destinationIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

}
