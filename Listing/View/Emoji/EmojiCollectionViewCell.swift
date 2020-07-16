//
//  EmojiCollectionViewCell.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "EmojiCell"
    
    @IBOutlet weak var iconLbl: UILabel!
    
    func configure(with label: String) {
        self.iconLbl.text = label
    }
    
    
}
