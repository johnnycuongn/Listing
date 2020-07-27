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
           
           let cellWidth = Double(ListsThumbnailCollectionViewCell.width)
           
               if Int(offset/cellWidth) <= listsManager.lists.count-1 && offset > 0 {
                       listIndex = Int(offset/cellWidth)
               } else if Int(offset/cellWidth) >= listsManager.lists.count {
                       listIndex = listsManager.lists.count-1
               } else if Int(offset/cellWidth) <= 0 {
                       listIndex = 0
               }
           
       }
       
       func addNewList() {
           isCreatingList = true

           let newList = List(emoji: "📝", title: "New List", items: [], index: listsManager.lists.count)
           listsManager.addList(newList)
           listIndex = listsManager.lists.count-1
           
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

extension ItemsViewController: CellUndoable {
    
    func undo(item: Item, with index: IndexPath) -> Bool {
        
        undoViewPresented(true)
        stopTimer()
        startTimer()
        
        self.deletedItem = item
        self.deletedItemIndex = index
        return true
    }

}
