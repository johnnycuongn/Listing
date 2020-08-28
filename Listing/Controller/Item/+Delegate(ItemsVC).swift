//
//  +Delegate.swift
//  Listing
//
//  Created by Johnny on 27/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController: ListUpdatable {
    func updateList(from offset: Double) {
           
        let cellWidth = Double(listsThumbnailWidth + listsThumbnailCollectionViewLayout.minimumLineSpacing)
        let index = Int((offset/cellWidth).rounded())
        
        if index <= currentMainList.subListsArray.count-1 && offset > 0 {
            listIndex = index
        } else if index >= currentMainList.subListsArray.count {
            listIndex = currentMainList.subListsArray.count-1
        } else if index <= 0 {
            listIndex = 0
        }
           
    }
       
    func addNewList() {
        isCreatingList = true

        currentMainList.addSubList(title: "New List", emoji: "📝")

           listIndex = currentMainList.subListsArray.count-1
           
           listTitleTextField.text = ""
           listTitleTextField.attributedPlaceholder = NSAttributedString(string: "Enter your title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

           setHidden(listTitleTextField: false)

           listTitleTextField.becomeFirstResponder()
           listTitleTextField.returnKeyType = .default
    }
       
}

extension ItemsViewController: PullDownToAddable {
    func isTablePullDowned(_ value: Bool) {
             if value == true {
                 if itemsTableView.contentOffset.y < -40 && !isKeyboardShowing {
                     self.addButtonTapped(addButton)
                 }
             }
         }
}

extension ItemsViewController: DataServiceActionSheetDelegate {
    func deleteAction(for indexPath: IndexPath) {
        // Reason: Animation might appear too fast
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.itemsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let deletedItem = currentSubList.itemsArray[indexPath.row]
        
        // Action Sheet
        let actionSheet = UIAlertController(
            title: nil,
            message: "'\(deletedItem.title!)' will be deleted permanently",
            preferredStyle: .actionSheet)
        
        // Delete
        let deleteAction = UIAlertAction(
            title: "Delete Task",
            style: .destructive) {
            (action) in
                self.currentSubList.deleteItem(at: indexPath.row)
                self.itemsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        
        // Cancel Delete
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.itemsTableView.reloadData()
        })
  
        
        // Present
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
}
