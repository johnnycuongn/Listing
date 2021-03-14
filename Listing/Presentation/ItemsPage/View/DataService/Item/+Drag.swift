//
//  +Drag.swift
//  Listing
//
//  Created by Johnny on 19/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsTableViewDataService: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return itemViewModel.dragItems(for: indexPath)
    }
    
    
}
