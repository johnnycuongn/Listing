//
//  SetUpData.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController {
    
    func setUpListsThumbnailCollectionViewData() {
        
        listsThumbnailCollectionView.dataSource = listsThumbnailCollectionViewDataService
        listsThumbnailCollectionView.delegate = listsThumbnailCollectionViewDataService
        
        listsThumbnailCollectionViewDataService.collectionView = listsThumbnailCollectionView
        
        
        // Delegation
        listsThumbnailCollectionViewDataService.listUpdateService = self
    }
    
    func setUpItemTableViewData() {
        itemsTableView.dataSource = itemsTableViewDataService
        itemsTableView.delegate = itemsTableViewDataService
        
        itemsTableView.dragDelegate = itemsTableViewDataService
        itemsTableView.dropDelegate = itemsTableViewDataService
        
        itemsTableViewDataService.tableView = itemsTableView
         
        // Delegation
        itemsTableViewDataService.delegate = self
    }
}
