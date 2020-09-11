//
//  +Delegates(MainListTblVCell).swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension MainListTableViewCell: ListsDeletable {

    func delete(list cell: SubListCollectionViewCell) {
        guard let indexPath = subListsCollectionView.indexPath(for: cell) else {
            return
        }
        
        guard currentMainList != nil else {
            return
        }

        let willDeletedList = currentMainList!.subListsArray[indexPath.row]

        let alert = UIAlertController(title: "\(willDeletedList.emoji) \(willDeletedList.title!)", message: "Delete List?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.currentMainList!.deleteSubList(at: indexPath.row)
            self.subListsCollectionView.deleteItems(at: [indexPath])

//            self.hasDeleted = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alertPresentDelegate?.present(alert)
        
    }


}
