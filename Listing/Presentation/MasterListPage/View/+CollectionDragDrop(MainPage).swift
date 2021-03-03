//
//  +DragDrop(MainPage).swift
//  Listing
//
//  Created by Johnny on 10/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

// MARK: DROP
extension MainPageViewController: UICollectionViewDropDelegate {

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
    }

    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first
            , let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                guard destinationIndexPath.row < viewModel.masterListCount else {
                    return
                }
                viewModel.moveMasterList(from: sourceIndexPath.row, to: destinationIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

}

// MARK: DRAG
extension MainPageViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard indexPath.row < MainListManager.mainLists.count else {
            return []
        }
        
        let list = viewModel.masterList.value[indexPath.row].title
        let itemProvider = NSItemProvider(object: list as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = list
        
        return [dragItem]
    }
}
