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

               if Int(offset/cellWidth) <= currentMainList.subListsArray.count-1 && offset > 0 {
                       listIndex = Int(offset/cellWidth)
               } else if Int(offset/cellWidth) >= currentMainList.subListsArray.count {
                       listIndex = currentMainList.subListsArray.count-1
               } else if Int(offset/cellWidth) <= 0 {
                       listIndex = 0
               }
           
       }
       
       func addNewList() {
           isCreatingList = true

//           let newList = List(emoji: "📝", title: "New List", items: [], index: currentMainList.subListsArray.count)
        currentMainList.addSubList(title: "New List", emoji: "📝")
//           currentMainList.addSubList(newList)
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
                 if listTableView.contentOffset.y < -40 && !isKeyboardShowing {
                     self.addButtonTapped(addButton)
                 }
             }
         }
}

extension ItemsViewController: DataServiceActionSheetDelegate {
    func deleteAction(for indexPath: IndexPath) {
        // Reason: Animation might appear too fast
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.listTableView.reloadRows(at: [indexPath], with: .automatic)
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
                self.listTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        
        // Cancel Delete
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Present
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
}
