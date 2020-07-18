//
//  ListsThumbnailCollectionViewDataService.swift
//  Listing
//
//  Created by Johnny on 17/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

public protocol ListUpdatable {
    func updateList(from offset: Double)
    
    func addNewList()
}

class ListsThumbnailCollectionViewDataService: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var listManager: ListsManager?
    var listIndex: Int?
        
    var listUpdateService: ListUpdatable?

    var collectionView: UICollectionView!

        // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard listManager != nil else { return 0 }
            return listManager!.lists.count+1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsThumbnailCollectionViewCell.identifier, for: indexPath) as! ListsThumbnailCollectionViewCell
  
        if indexPath.row == listManager!.lists.count {
            cell.configure(with: "+")
        }
        else if indexPath.row < listManager!.lists.count {
            cell.configure(with: listManager!.lists[indexPath.row].emoji)
        }
        
        return cell
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listUpdateService?.updateList(from: Double(collectionView.contentOffset.x))
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == listManager!.lists.count {
            listUpdateService?.addNewList()
        } else {
            self.collectionView.scrollToItem(at: IndexPath(row: indexPath.row+1, section: 0), at: .right, animated: true)
        }
    }

        /*
        // Uncomment this method to specify if the specified item should be highlighted during tracking
        override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        */

        /*
        // Uncomment this method to specify if the specified item should be selected
        override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        */

        /*
        // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
        override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
            return false
        }

        override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
            return false
        }

        override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        }
        */


}
