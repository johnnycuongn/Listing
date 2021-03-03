//
//  +CollectionView(MasterListPage).swift
//  Listing
//
//  Created by Johnny on 3/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit

// MARK: - FLOW LAYOUT

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainListCollectionView.frame.width,
                      height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - DATA SOURCE

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.masterListCount + 1
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCollectionViewCell.identifier, for: indexPath) as? MainListCollectionViewCell else {
            print("MainPageViewController: Can't dequeue collection view cell at \(indexPath)")
            return UICollectionViewCell()
        }
        
        if indexPath.row == viewModel.masterListCount {
            cell.config(with: "+")
        }
        else {
            
            
            let mainList = viewModel.masterList.value[indexPath.row]
            cell.config(with: mainList.title ?? "No Value")
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - DELEGATE 

extension MainPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < viewModel.masterListCount {
            print("MainList Selected: \(MainListManager.mainLists[indexPath.row].title)")
            let vc = ItemsViewController.initialize(with: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == viewModel.masterListCount {
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
        viewModel.moveMasterList(from: sourceIndexPath.row, to: destinationIndexPath.row)
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
