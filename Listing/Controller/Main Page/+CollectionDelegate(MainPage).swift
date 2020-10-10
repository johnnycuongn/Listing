//
//  + CollectionDelegate(MainPage).swift
//  Listing
//
//  Created by Johnny on 10/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit


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
