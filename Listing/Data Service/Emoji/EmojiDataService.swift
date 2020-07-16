//
//  EmojiDataService.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class EmojiDataService: NSObject, UICollectionViewDelegate, UICollectionViewDataSource
{
    var categories = EmojiProvider.categories
    
    // MARK: - Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EmojiProvider.categoryTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
            
        let sectionData = categories[indexPath.section]
        let data = sectionData.emojis[indexPath.row]
            if data.isSingleEmoji {
                cell.configure(with: data)
            }
        
        return cell
    }
    
    // MARK: Section Header View
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
        
        let category = categories[indexPath.section].name
        
        sectionHeaderView.cagtegoryTitle = category
        
        return sectionHeaderView
    }
    

}

