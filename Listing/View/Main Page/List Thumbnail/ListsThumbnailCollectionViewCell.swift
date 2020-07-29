//
//  ListsThumbnailCollectionViewCell.swift
//  Listing
//
//  Created by Johnny on 17/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListsThumbnailCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "ListsThumbnailCell"
    
    @IBOutlet weak var emojiThumbnailLabel: UILabel!
    
    func configure(with emoji: String) {
        self.emojiThumbnailLabel.text = emoji
        
    }
    
    func configureView(of frame: CGRect) {
        contentView.layer.cornerRadius = frame.size.height/2
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
}
