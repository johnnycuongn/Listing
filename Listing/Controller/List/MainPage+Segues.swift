//
//  MainPage+Segues.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ListsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toItemsVC {
            let itemsVC = segue.destination as! ItemsViewController
            guard let selectedIndex = mainListsTableView.indexPathForSelectedRow else {
                print("onLT THIS HOHO")
                itemsVC.mainListIndexPath = selectedIndexPath
                return
            }
            itemsVC.mainListIndexPath = selectedIndex
        }
    }
}
