//
//  +DragDelegate.swift
//  Listing
//
//  Created by Johnny on 19/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ListsViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let list = currentMainList.subListsArray[indexPath.row].title
        let itemProvider = NSItemProvider(object: list! as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = list
        
        return [dragItem]
    }
}
