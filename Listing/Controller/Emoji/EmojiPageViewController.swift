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
    
    @IBOutlet weak var emojiSearchBar: UISearchBar!
    var selectedEmoji: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiCollectionView.delegate = emojiDataService
        emojiCollectionView.dataSource = emojiDataService
    
        emojiDataService.collectionView = emojiCollectionView
        emojiDataService.searchBar = emojiSearchBar
        
        emojiSearchBar.delegate = emojiDataService
        
        emojiCollectionView.reloadData()     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == Segues.unwind.saveEmoji {
            guard let indexPath = emojiCollectionView.indexPathsForSelectedItems?.first else {
                return
            }
            
            let categories = EmojiProvider.categories
            let sectionData = categories[indexPath.section]
            let data = sectionData.emojis[indexPath.row]
            
            self.selectedEmoji = data.emoji
        }
    }
    
    
    
}
