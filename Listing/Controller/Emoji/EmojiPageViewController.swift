//
//  EmojiPageViewController.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class EmojiPageViewController: UIViewController {
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    
    @IBOutlet weak var emojiDataService: EmojiDataService!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emojiCollectionView.delegate = emojiDataService
        emojiCollectionView.dataSource = emojiDataService
        
        emojiCollectionView.reloadData()
        
        
    }
    
    
}
