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
    
    var layout: UICollectionViewFlowLayout {
        return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    var frame: CGRect {
        return collectionView.frame
    }

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
        cell.configureView(of: frame)
        
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
            self.collectionView.contentOffset.x = frame.size.height*CGFloat(indexPath.row)+layout.minimumLineSpacing*CGFloat(indexPath.row)
        }
    }

}
