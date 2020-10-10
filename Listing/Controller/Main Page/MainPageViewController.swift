//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit
import SwipeCellKit

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




extension MainPageViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            
            action.fulfill(with: .delete)
            self.actionSheetForDelete(for: indexPath)

        }
        
        let trashImage =  UIImage(systemName: "trash")!
        deleteAction.image = trashImage
            .withTintColor(AssetsColor.destructive, renderingMode: .alwaysOriginal)
        
        deleteAction.backgroundColor = .clear

        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        options.backgroundColor = .clear
        
        return options
    }
    
    
}




