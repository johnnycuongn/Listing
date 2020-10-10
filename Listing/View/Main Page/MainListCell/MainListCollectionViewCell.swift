//
//  MainListCollectionViewCell.swift
//  Listing
//
//  Created by Johnny on 10/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class MainListCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: MainListCollectionViewCell.self)
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        contentView.layer.cornerRadius = 25
        
        layer.cornerRadius = 7
        
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
    
    }
    
    func config(with title: String) {
        self.title.text = title
    }
}
