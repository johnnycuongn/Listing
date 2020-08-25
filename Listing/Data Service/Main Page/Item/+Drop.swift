//
//  +Drop.swift
//  Listing
//
//  Created by Johnny on 19/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsTableViewDataService: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return currentSubList.canHandle(session)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
         let destinationIndexPath: IndexPath
               
               if let indexPath = coordinator.destinationIndexPath {
                   destinationIndexPath = indexPath
               } else {
                   // Get last index path of table view.
                   let section = tableView.numberOfSections - 1
                   let row = tableView.numberOfRows(inSection: section)
                   destinationIndexPath = IndexPath(row: row, section: section)
               }
               
               coordinator.session.loadObjects(ofClass: NSString.self) { items in
                   // Consume drag items.
                   let stringItems = items as! [String]
                   
                   var indexPaths = [IndexPath]()
                   for (index, item) in stringItems.enumerated() {
                       let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    self.currentSubList.insertItem(item, at: indexPath.row)
                       indexPaths.append(indexPath)
                   }

                   tableView.insertRows(at: indexPaths, with: .automatic)
               }
    }
    
}
