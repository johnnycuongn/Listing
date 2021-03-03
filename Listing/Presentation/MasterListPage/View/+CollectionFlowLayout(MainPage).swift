//
//  +CollectionDelegateFlowLayout(MainPage).swift
//  Listing
//
//  Created by Johnny on 10/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainListCollectionView.frame.width,
                      height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
