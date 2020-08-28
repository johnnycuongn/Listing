//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

struct MainPageStoryBoard {
    static var tableViewTopAnchor: CGFloat = 60
    static var largestTableViewHeight: CGFloat {
        return UIScreen.main.bounds.size.height - tableViewTopAnchor*2
    }
}

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
        mainListsTableView.bounces = false
    }

}


