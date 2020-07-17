//
//  ListTableViewDataService.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListTableViewDataService: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    var listsManager: ListsManager?
    var listIndex: Int?
    
    var currentList: List {
        guard listsManager != nil else { fatalError() }
        guard listIndex != nil else { fatalError() }
        print("Data Service: \(listIndex)")
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
    
        
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        switch editingStyle {
    //        case .delete:
    //             guard let listManager = self.listManager else { fatalError() }
    //
    //            listManager.deleteItem(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        default: break
    //        }
    //    }
    
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        currentList.deleteItem(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    

    

    
    
    
    
    

}
