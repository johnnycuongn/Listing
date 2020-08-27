//
//  ListTableViewDataService.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

public protocol PullDownToAddable {
    func isTablePullDowned(_ value: Bool)
}

protocol DataServiceActionSheetDelegate {
    func deleteAction(for indexPath: IndexPath)
}

class ItemsTableViewDataService: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var currentMainList: MainList {
        return MainListManager.mainLists[0]
    }
    var listIndex: Int?
    var pullDownService: PullDownToAddable!
    var actionSheet: DataServiceActionSheetDelegate!
    
    var currentSubList: SubList {
        guard listIndex != nil else { fatalError() }
        
        return currentMainList.subListsArray[listIndex!]
    }

    // MARK: - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSubList.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        cell.swipeToDeleteDelegate = self
        
        let item = currentSubList.itemsArray[indexPath.row]
        cell.config(item: item)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if (tableView.isEditing) {
//            return .none
//        } else {
//            return .delete
//        }
//    }
    
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        currentSubList.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, boolValue) in
            
            self.actionSheet.deleteAction(for: indexPath)
            
        }
        let trashImage =  UIImage(systemName: "trash")
        deleteAction.image = trashImage?.withTintColor(AssetsColor.destructive, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = AssetsColor.lightDarkGrey
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullDownService.isTablePullDowned(true)
    }
}

extension ItemsTableViewDataService: SwipeItemToDeleteDelegate {
    
    func isComplete(_ item: ItemCell) -> Bool {
        guard let indexPath = tableView.indexPath(for: item) else {
            print("Unable to find item")
            return false
        }
        
        let selectedItem = currentSubList.itemsArray[indexPath.row]
        
        return selectedItem.isCompleted
        
    }

    func updateComplete(for item: ItemCell, with isComplete: Bool) {
        guard let indexPath = tableView.indexPath(for: item) else {
            print("Unable to find item")
            return
        }
        
        let selectedItem = currentSubList.itemsArray[indexPath.row]
        selectedItem.updateComplete(with: isComplete)
    }
}
