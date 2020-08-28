//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var listsCollectionView: UICollectionView!
    
    @IBOutlet weak var mainListsTableView: UITableView!
    
    
    var currentMainList: MainList {
        return MainListManager.mainLists[0]
    }
    
    var selectedIndexPath: IndexPath?
    
    var hasDeleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasDeleted = false
        
        mainListsTableView.delegate = self
        mainListsTableView.dataSource = self
        
    }

}
extension ListsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPath == nil {
            return 60
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainListManager.mainLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListTableViewCell.identifier, for: indexPath) as? MainListTableViewCell else {
            fatalError()
        }
        
        let mainList = MainListManager.mainLists[0]
        
        cell.config(with: mainList.title!)
        cell.indexPath = indexPath
        
        cell.expandDelegate = self
        cell.segueDelegate = self
        cell.alertPresentDelegate = self
        
        return cell
    }
    
    
}

extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexPath == nil, let selected = mainListsTableView.indexPathForSelectedRow  {
            selectedIndexPath = selected
        }
        else {
            selectedIndexPath = nil
        }
        
        mainListsTableView.reloadData()
    }
}

extension ListsViewController: ListsDeletable {
    
    func delete(list cell: SubListCollectionViewCell) {
        guard let indexPath = listsCollectionView.indexPath(for: cell) else {
            return
        }
        
        let willDeletedList = currentMainList.subListsArray[indexPath.row]
        
        let alert = UIAlertController(title: "\(willDeletedList.emoji) \(willDeletedList.title!)", message: "Delete List?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.currentMainList.deleteSubList(at: indexPath.row)
            self.listsCollectionView.deleteItems(at: [indexPath])
            
            self.hasDeleted = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
