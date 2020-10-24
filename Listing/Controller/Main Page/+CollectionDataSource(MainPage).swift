//
//  +CollectionDataSource(MainPage).swift
//  Listing
//
//  Created by Johnny on 10/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return MainListManager.mainLists.count + 1
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCollectionViewCell.identifier, for: indexPath) as? MainListCollectionViewCell else {
            print("MainPageViewController: Can't dequeue collection view cell at \(indexPath)")
            return UICollectionViewCell()
        }
        
        if indexPath.row == MainListManager.mainLists.count {
            cell.config(with: "+")
        }
        else {
            
            
            let mainList = MainListManager.mainLists[indexPath.row]
            cell.config(with: mainList.title ?? "No Value")
            cell.delegate = self
        }
        
        return cell
    }
}
