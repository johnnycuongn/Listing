//
//  ItemCell.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(item: Item) {
        
        self.titleLabel.attributedText = item.title!.strikeThrough(.remove)
        
        
        if item.isCompleted == true {
            self.titleLabel.attributedText = item.title!.strikeThrough(.add)
        }
        
    }

}
