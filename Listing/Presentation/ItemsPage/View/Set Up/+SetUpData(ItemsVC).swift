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
    func loadListIndex() {
        listTableViewDataUpdate()
        listsThumbnailCollectionViewDataUpdate()
    }
    
    func setUpListsThumbnailCollectionViewData() {
        
        listsThumbnailCollectionView.dataSource = listsThumbnailCollectionViewDataService
        listsThumbnailCollectionView.delegate = listsThumbnailCollectionViewDataService
        
        listsThumbnailCollectionViewDataService.collectionView = listsThumbnailCollectionView
        
        listsThumbnailCollectionViewDataService.currentMainListIndex = mainListIndexPath.row
        
        // Delegation
        listsThumbnailCollectionViewDataService.listUpdateService = self
    }
    
    func setUpItemTableViewData() {
        itemsTableView.dataSource = itemsTableViewDataService
        itemsTableView.delegate = itemsTableViewDataService
        
        itemsTableView.dragDelegate = itemsTableViewDataService
        itemsTableView.dropDelegate = itemsTableViewDataService
        
        itemsTableViewDataService.tableView = itemsTableView
        itemsTableViewDataService.currentMainListIndex = mainListIndexPath.row
         
        // Delegation
        itemsTableViewDataService.pullDownService = self
        itemsTableViewDataService.actionSheet = self
    }
}
