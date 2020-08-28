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
        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        
        listTableView.dragDelegate = dataService
        listTableView.dropDelegate = dataService
        
        dataService.tableView = listTableView
         
        // Delegation
        dataService.pullDownService = self
        dataService.actionSheet = self
    }
}
