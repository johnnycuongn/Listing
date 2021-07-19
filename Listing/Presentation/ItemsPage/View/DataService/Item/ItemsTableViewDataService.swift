//
//  ListTableViewDataService.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

public protocol ScrollActionDelegate {
    func pullTable(_ value: Bool)
}

public protocol DataServiceActionSheetDelegate {
    func deleteAction(for indexPath: IndexPath)
}

public protocol ItemsTableViewDelegate: ScrollActionDelegate, DataServiceActionSheetDelegate {
    
    func editItem(at index: Int)
    
}

class ItemsTableViewDataService: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    var delegate: ItemsTableViewDelegate!

    fileprivate var scollAction: ScrollActionDelegate {
        return delegate
    }
    fileprivate var actionSheet: DataServiceActionSheetDelegate {
        return delegate
    }
    
    var itemViewModel: ItemListViewModel!

    // MARK: - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        cell.swipeToDeleteDelegate = self
        
        let item = itemViewModel.items.value[indexPath.row]
        cell.fill(with: item)
        
        return cell
    }

    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        itemViewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.editItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, boolValue) in
            
            self.actionSheet.deleteAction(for: indexPath)
            
        }
        let trashImage =  UIImage(systemName: "trash")!
        deleteAction.image = trashImage.withTintColor(AssetsColor.destructive, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = AssetsColor.darkGrey2
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scollAction.pullTable(true)
    }
}

extension ItemsTableViewDataService: SwipeItemToDeleteDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func isComplete(_ item: ItemCell) -> Bool {
        guard let indexPath = tableView.indexPath(for: item) else {
            return false
        }
        
        let selectedItem = itemViewModel.items.value[indexPath.row]
        
        return selectedItem.isCompleted
        
    }

    func updateComplete(for item: ItemCell, with isComplete: Bool) {
        guard let indexPath = tableView.indexPath(for: item) else {
            return
        }

        switch isComplete {
        case true:
            itemViewModel.completeItem(at: indexPath.row)
        case false:
            itemViewModel.uncompleteItem(at: indexPath.row)
        }
        
    }
}
