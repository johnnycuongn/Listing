//
//  +CollectionDataSource.swift
//  Listing
//
//  Created by Johnny on 27/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ListsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMainList.subListsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsCollectionViewCell.identifier, for: indexPath) as! ListsCollectionViewCell
        
        let subList = currentMainList.subListsArray[indexPath.row]
        
        cell.configure(emoji: subList.emoji!, title: subList.title!)
        cell.listsDeletionService = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
         return true
     }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
           currentMainList.moveSubList(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

}
