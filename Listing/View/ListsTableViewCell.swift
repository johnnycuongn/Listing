//
//  ListsTableViewCell.swift
//  Listing
//
//  Created by Johnny on 18/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListsTableViewCell: UITableViewCell {
    
    static var identifier = "ListCell"

    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var listTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(withEmoji: String, title: String) {
        self.emojiButton.setTitle(withEmoji, for: .normal)
        self.listTitleLabel.text = title
    }

}
