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
    
    static var size = CGFloat(55)
    
    @IBOutlet weak var emojiThumbnailLabel: UILabel!
    
    func configure(with emoji: String) {
        self.emojiThumbnailLabel.text = emoji
    }
    
}
