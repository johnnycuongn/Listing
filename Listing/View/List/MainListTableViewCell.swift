//
//  MainListTableViewCell.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol MainListCellExpandDelegate {
    func expandCell(_ cell: MainListTableViewCell)
}

protocol MainListCellPerformSegueDelegate {
    func performSegue(with subListIndex: Int)
}

protocol MainListCellAlertPresentDelegate {
    func present(_ alert: UIAlertController)
}

class MainListTableViewCell: UITableViewCell {
    static let identifier = "MainListTableViewCell"
    
    @IBOutlet weak var mainListTitle: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    
    @IBOutlet weak var subListsCollectionView: UICollectionView!
    
    var isExpanded = false
    
    var indexPath: IndexPath? {
        didSet {
            subListsCollectionView.reloadData()
        }
    }
    
    var currentMainList: MainList? {
        guard indexPath != nil else {
            fatalError()
        }
        return MainListManager.mainLists[indexPath!.row]
    }
    var subLists: [SubList]? {
        guard currentMainList != nil else { return [] }
        return currentMainList!.subListsArray
    }
    
    var expandDelegate: MainListCellExpandDelegate?
    var segueDelegate: MainListCellPerformSegueDelegate?
    var alertPresentDelegate: MainListCellAlertPresentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subListsCollectionView.delegate = self
        subListsCollectionView.dataSource = self
        
        subListsCollectionView.dragDelegate = self
        subListsCollectionView.dropDelegate = self
        subListsCollectionView.dragInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(with title: String) {
        self.mainListTitle.text = title
    }
    
    @IBAction func expandTapped(_ sender: UIButton) {
        expandDelegate?.expandCell(self)
    }
    
    

}

extension MainListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


// FIXME:
extension MainListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard subLists != nil else {
            return 0
        }
        return subLists!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubListCollectionViewCell.identifier, for: indexPath) as? SubListCollectionViewCell else {
            fatalError()
            return UICollectionViewCell()
        }
        
        guard subLists != nil else {
            fatalError()
        }
        
        let subList = subLists![indexPath.row]
        
        cell.config(emoji: subList.emoji! , title: subList.title!)
        cell.listsDeletionService = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        segueDelegate?.performSegue(with: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        currentMainList!.moveSubList(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}


// FIXME: Drag Delegate
extension MainListTableViewCell: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let list = currentMainList!.subListsArray[indexPath.row].title
        let itemProvider = NSItemProvider(object: list! as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = list
        
        return [dragItem]
    }
}

// FIXME: Drop Delegate
extension MainListTableViewCell: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UICollectionViewDropProposal(operation: .forbidden)
    }


    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }

        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }

    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first
            , let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.currentMainList!.moveSubList(from: sourceIndexPath.row, to: destinationIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

}

extension MainListTableViewCell: ListsDeletable {

    func delete(list cell: SubListCollectionViewCell) {
        guard let indexPath = subListsCollectionView.indexPath(for: cell) else {
            return
        }
        
        guard currentMainList != nil else {
            return
        }

        let willDeletedList = currentMainList!.subListsArray[indexPath.row]

        let alert = UIAlertController(title: "\(willDeletedList.emoji) \(willDeletedList.title!)", message: "Delete List?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            self.currentMainList!.deleteSubList(at: indexPath.row)
            self.subListsCollectionView.deleteItems(at: [indexPath])

//            self.hasDeleted = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alertPresentDelegate?.present(alert)
        
    }


}
