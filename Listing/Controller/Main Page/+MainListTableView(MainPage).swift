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
extension MainPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPath == nil {
            return 60
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainListManager.mainLists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListTableViewCell.identifier, for: indexPath) as? MainListTableViewCell else {
            fatalError()
        }
        
        if indexPath.row == MainListManager.mainLists.count {
            cell.config(with: "+")
            cell.expandButton.isHidden = true
            cell.settingButton.isHidden = true
        
        }
        else {
            
            
            let mainList = MainListManager.mainLists[indexPath.row]
            
            cell.config(with: mainList.title!)
            cell.indexPath = indexPath
            
            cell.expandDelegate = self
            cell.segueDelegate = self
            cell.alertPresentDelegate = self
            
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < MainListManager.mainLists.count else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, bool) in
            self.actionSheetForDelete(for: indexPath)
        }
        
        let trashImage =  UIImage(systemName: "trash")!
        deleteAction.image = trashImage.withTintColor(.lightGray)
        deleteAction.backgroundColor = AssetsColor.destructive
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

// MARK: Delegate
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < MainListManager.mainLists.count {
//            if selectedIndexPath == nil, let selected = mainListsTableView.indexPathForSelectedRow  {
//                selectedIndexPath = selected
//            }
//            else {
//                selectedIndexPath = nil
//            }
            performSegue(withIdentifier: Segues.toItemsVC, sender: nil)

        } else if indexPath.row == MainListManager.mainLists.count {
//            addNewMainList()
            MainListManager.append(title: "New list")
            tableView.insertRows(at: [IndexPath(row: MainListManager.mainLists.count-1, section: 0)], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == MainListManager.mainLists.count-1 {
            adjustTableViewHeight(reload: false)
        }
    }
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
                self.mainListsTableView.deleteRows(at: [indexPath], with: .fade)
                
                self.adjustTableViewHeight(reload: false)
                   
            }
           
           // Cancel Delete
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.mainListsTableView.reloadData()
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
                
                self.mainListsTableView.insertRows(at: [IndexPath(row: MainListManager.mainLists.count-1, section: 0)], with: .fade)

                self.adjustTableViewHeight(reload: false)
                
                
                
            }))
        
        alertView.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func adjustTableViewHeight(reload: Bool) {
        if reload {
            self.mainListsTableView.reloadData()
        }
        
        if self.mainListsTableView.contentSize.height < MainPageStoryBoard.largestTableViewHeight {
            self.tableViewHeight.constant = self.mainListsTableView.contentSize.height
            self.mainListsTableView.layoutIfNeeded()
        } else {
             self.tableViewHeight.constant = MainPageStoryBoard.largestTableViewHeight
        }
    }
    
}
