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
    
    var listsManager: ListsManager?
    
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
    
}

extension ListsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ListsDeletable {
    
    // MARK: Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.listsCollectionView.frame.size.width)/2.2, height: self.listsCollectionView.frame.size.height / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listsManager!.lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsCollectionViewCell.identifier, for: indexPath) as! ListsCollectionViewCell
        
        let list = listsManager!.lists[indexPath.row]
        
        cell.configure(emoji: list.emoji, title: list.title)
        cell.listsDeletionService = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        listsManager!.moveList(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    
    func delete(list cell: ListsCollectionViewCell) {
        guard let indexPath = listsCollectionView.indexPath(for: cell) else {
            return
        }
        
        let alert = UIAlertController(title: "List Deletion", message: "Are you sure to delete this list?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.listsManager!.deleteList(at: indexPath.row)
            self.listsCollectionView.deleteItems(at: [indexPath])
            
            self.hasDeleted = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.unwind.selectedList {
            let listVC = segue.destination as! ItemsViewController
        }
    }
    

}
