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
        
        // Delegation
        listsThumbnailCollectionViewDataService.listUpdateService = self
    }
    
    func setUpItemTableViewData() {
        itemsTableView.dataSource = dataService
        itemsTableView.delegate = dataService
        
        itemsTableView.dragDelegate = dataService
        itemsTableView.dropDelegate = dataService
        
        dataService.tableView = itemsTableView
         
        // Delegation
        dataService.pullDownService = self
        dataService.actionSheet = self
    }
}
