//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

//struct MainPageStoryBoard {
//    static var tableViewTopAnchor: CGFloat = 60
//    static var largestTableViewHeight: CGFloat {
//        return UIScreen.main.bounds.size.height - tableViewTopAnchor*2
//    }
//}

class MainPageViewController: UIViewController {
    

    var selectedIndexPath: IndexPath?

    @IBOutlet weak var mainListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainListCollectionView.delegate = self
        mainListCollectionView.dataSource = self
        
        mainListCollectionView.dropDelegate = self
        mainListCollectionView.dragDelegate = self
        mainListCollectionView.dragInteractionEnabled = true
    }
}









