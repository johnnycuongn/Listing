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

class ItemsTableViewDataService: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    var currentMainList: MainList {
        return MainListManager.mainLists[0]
    }
    var listIndex: Int?
    var pullDownService: PullDownToAddable!
    
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

        cell.config(item: currentSubList.itemsArray[indexPath.row])
        
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullDownService.isTablePullDowned(true)
    }
 

}
