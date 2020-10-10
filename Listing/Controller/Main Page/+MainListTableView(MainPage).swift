//
//  +MainListTableView(MainPage).swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

// MARK: Data Source
extension MainPageViewController {
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        guard indexPath.row < MainListManager.mainLists.count else {
//            return nil
//        }
//        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, bool) in
//            self.actionSheetForDelete(for: indexPath)
//        }
//
//        let trashImage =  UIImage(systemName: "trash")!
//        deleteAction.image = trashImage.withTintColor(.lightGray)
//        deleteAction.backgroundColor = AssetsColor.destructive
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
    
}

// MARK: Helper
extension MainPageViewController {
    
    func actionSheetForDelete(for indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: "\(MainListManager.mainLists[indexPath.row].title!)", preferredStyle: .actionSheet)
           
        let deleteAction = UIAlertAction(
            title: "Delete",
            style: .destructive) {
            (action) in
                MainListManager.remove(at: indexPath.row)
                self.mainListCollectionView.deleteItems(at: [indexPath])
            }
           
           // Cancel Delete
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.mainListCollectionView.reloadData()
        })
           
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
           
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func addNewMainList() {
        let alertView = UIAlertController(title: nil, message: "New List", preferredStyle: .alert)
        
        alertView.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        alertView.addAction(
            UIAlertAction(title: "Add", style: .default, handler: { (action) in
                guard let title = alertView.textFields?.first else {
                    return
                }
                
                MainListManager.append(title: title.text!)
                
                self.mainListCollectionView.insertItems(at: [IndexPath(row: MainListManager.mainLists.count-1, section: 0)])
            }))
        
        alertView.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }

}
