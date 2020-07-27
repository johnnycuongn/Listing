//
//  ListsCollectionViewCell.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol ListsDeletable {
    func delete(list cell: ListsCollectionViewCell)
}

class ListsCollectionViewCell: UICollectionViewCell {
    static var identifier = "ListsCollectionViewCell"
    
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var listTitleLabel: UILabel!
    
    var listsDeletionService: ListsDeletable?
    
    
    @IBAction func deleteListTapped(_ sender: UIButton) {
        listsDeletionService?.delete(list: self)
    }
    
    
    func configure(emoji: String, title: String) {
        self.emojiButton.setTitle(emoji, for: .normal)
        
        self.listTitleLabel.text = title
        setUpCellView()
    }
    
    func setUpCellView() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
    
}
