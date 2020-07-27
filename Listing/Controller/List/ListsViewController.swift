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
    
    var listsManager: ListsManager!
    
    var hasDeleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasDeleted = false
        
        listsCollectionView.dataSource = self
        listsCollectionView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.performSegue(withIdentifier: Segues.unwind.selectedList, sender: nil)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.unwind.selectedList {
            let listVC = segue.destination as! ItemsViewController
        }
    }
}

extension ListsViewController: ListsDeletable {
    
    func delete(list cell: ListsCollectionViewCell) {
        guard let indexPath = listsCollectionView.indexPath(for: cell) else {
            return
        }
        
        let willDeletedList = listsManager.lists[indexPath.row]
        
        let alert = UIAlertController(title: "\(willDeletedList.emoji) \(willDeletedList.title)", message: "Delete List?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.listsManager.deleteList(at: indexPath.row)
            self.listsCollectionView.deleteItems(at: [indexPath])
            
            self.hasDeleted = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
