//
//  ListsTableViewController.swift
//  Listing
//
//  Created by Johnny on 18/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController, ListsDeletable {

    var listsManager: ListsManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.performSegue(withIdentifier: Segues.selectedList, sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsManager!.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListsTableViewCell.identifier, for: indexPath) as! ListsTableViewCell
        
        let list = listsManager!.lists[indexPath.row]

        cell.listsDeleteService = self
        cell.configure(withEmoji: list.emoji, title: list.title)

        return cell
    }
    
    func delete(list cell: ListsTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let alert = UIAlertController(title: "List Deletion", message: "Are you sure to delete this list?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.listsManager!.deleteList(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        listsManager!.moveList(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (tableView.isEditing) {
            return .none
        } else {
            return .delete
        }
    }
    
    // MARK: - Bar Buttons Action
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func addListButtonTapped(_ sender: Any) {
    }

    
//     MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.selectedList {
            let listVC = segue.destination as! ListViewController
        }
    }
    
    
    

}
