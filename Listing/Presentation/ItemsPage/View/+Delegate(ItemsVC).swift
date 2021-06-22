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
    
    /// Update corresponding sublist based on scrolling offset
    /// - Parameter offset: Sublist's collection view offset
    func updateList(from offset: Double) {
           
        let cellWidth = Double(listsThumbnailWidth + listsThumbnailCollectionViewLayout.minimumLineSpacing)
        let index = Int((offset/cellWidth).rounded())
        
        if index <= pageViewModel.subLists.value.count-1 && offset > 0 {
            self.subListCurrentIndex = index
        } else if index >= pageViewModel.subLists.value.count {
            self.subListCurrentIndex = pageViewModel.subLists.value.count-1
        } else if index <= 0 {
            self.subListCurrentIndex = 0
        }
           
    }
       
    func addNewList() {
        controllerState.isCreatingList = true

        pageViewModel.addSubList(title: "Untitled", emoji: "📝")

        self.subListCurrentIndex = pageViewModel.subLists.value.count-1
           
           listTitleTextField.text = ""
           listTitleTextField.attributedPlaceholder = NSAttributedString(string: "Enter your title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

           editSubListTitle(true)

           listTitleTextField.becomeFirstResponder()
           listTitleTextField.returnKeyType = .default
    }
       
}

// MARK: Items Table View
extension ItemsViewController: ItemsTableViewDelegate {
    func pullTable(_ value: Bool) {
        if value == true {
            let yOffset = itemsTableView.contentOffset.y
            let tableHeight = itemsTableView.bounds.height
            let contentHeight = itemsTableView.contentSize.height
                
            if  /* Pull up */ (yOffset < -40) ||
                /* Pull down when n.o items are within 1 view */ (contentHeight < tableHeight && yOffset > 40) ||
                /* Pull down when n.o items are large */ (contentHeight > tableHeight && (yOffset + tableHeight) - contentHeight > 40) {
                self.activateItemInputToolbar(type: .addNewItem)
            }
        }
    }

    func deleteAction(for indexPath: IndexPath) {
        // Reason: Animation might appear too fast
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.itemsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let deletedItem = pageViewModel.items.value[indexPath.row]
        
        // Action Sheet
        let actionSheet = UIAlertController(
            title: nil,
            message: "'\(deletedItem.title)' will be deleted permanently",
            preferredStyle: .actionSheet)
        
        // Delete
        let deleteAction = UIAlertAction(
            title: "Delete Task",
            style: .destructive) {
            (action) in

            self.pageViewModel.deleteItem(at: indexPath.row)
//            self.itemsTableView.deleteRows(at: [indexPath], with: .automatic)
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
    
    func editItem(at index: Int) {
        inputItemTextView.text = pageViewModel.items.value[index].title
        inputItemTextView.textColor = UIColor.white
        inputItemTextView.selectedTextRange = inputItemTextView.textRange(
            from: inputItemTextView.endOfDocument,
            to: inputItemTextView.endOfDocument)
        
        activateItemInputToolbar(type: .updateCurrentItem(index: index))
       
    }
    
    @objc func tableTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.itemsTableView)
        let path = self.itemsTableView.indexPathForRow(at: location)
        
        // handle tap on empty space below existing rows however you want
        if path == nil {
            resetInputTextView()
            activateItemInputToolbar(type: .addNewItem)
        }
    }
    
}
