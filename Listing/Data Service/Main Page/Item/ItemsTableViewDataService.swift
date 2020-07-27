//
//  ListTableViewDataService.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol CellUndoable {
    func undo(item: Item, with index: IndexPath) -> Bool
}

public protocol PullDownToAddable {
    func isTablePullDowned(_ value: Bool)
}

class ItemsTableViewDataService: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    var listsManager: ListsManager?
    var listIndex: Int?
    var pullDownService: PullDownToAddable!
    var cellUndoable: CellUndoable!
    
    var currentList: List {
        guard listsManager != nil else { fatalError() }
        guard listIndex != nil else { fatalError() }
        
        return listsManager!.lists[listIndex!]
    }

    // MARK: - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell

        
        cell.config(item: currentList.items[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        currentList.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (tableView.isEditing) {
            return .none
        } else {
            return .delete
        }
    }
    
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let deletedIndexPath = indexPath
        let deletedItem = currentList.items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        cellUndoable.undo(item: deletedItem, with: deletedIndexPath)
//            self.currentList.deleteItem(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullDownService.isTablePullDowned(true)
    }

    

    

    
    
    
    
    

}