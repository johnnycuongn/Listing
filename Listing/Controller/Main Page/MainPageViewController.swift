//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var mainListsTableView: UITableView!

    var selectedIndexPath: IndexPath?

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainListsTableView.delegate = self
        mainListsTableView.dataSource = self
        
        mainListsTableView.layer.cornerRadius = 25
        mainListsTableView.alwaysBounceVertical = false
    }

}


