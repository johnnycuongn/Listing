//
//  MainListTableViewCell.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol MainListCellExpandDelegate {
    func expandCell(_ cell: MainListTableViewCell)
}

protocol MainListCellPerformSegueDelegate {
    func performSegue(with subListIndex: Int)
}

protocol MainListCellAlertPresentDelegate {
    func present(_ alert: UIAlertController)
}

class MainListTableViewCell: UITableViewCell {
    static let identifier = "MainListTableViewCell"
    
    @IBOutlet weak var mainListTitle: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    @IBOutlet weak var subListsCollectionView: UICollectionView!
    
    var isExpanded = false
    
    var indexPath: IndexPath? {
        didSet {
            subListsCollectionView.reloadData()
        }
    }
    
    var currentMainList: MainList? {
        guard indexPath != nil else {
//            fatalError()
            return nil
        }
        return MainListManager.mainLists[indexPath!.row]
    }
    var subLists: [SubList]? {
        guard currentMainList != nil else { return [] }
        return currentMainList!.subListsArray
    }
    
    var expandDelegate: MainListCellExpandDelegate?
    var segueDelegate: MainListCellPerformSegueDelegate?
    var alertPresentDelegate: MainListCellAlertPresentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subListsCollectionView.delegate = self
        subListsCollectionView.dataSource = self
        
        subListsCollectionView.dragDelegate = self
        subListsCollectionView.dropDelegate = self
        subListsCollectionView.dragInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(with title: String) {
        self.mainListTitle.text = title
        expandButton.isHidden = false
        settingButton.isHidden = false
    }
    
    @IBAction func expandTapped(_ sender: UIButton) {
        expandDelegate?.expandCell(self)
    }
    
    

}



