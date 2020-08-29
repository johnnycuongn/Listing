//
//  EmojiDataService.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol EmojiSelectDelegate {
    func selectedEmoji(_ emoji: String)
}


class EmojiDataService: NSObject, UICollectionViewDelegate, UICollectionViewDataSource
{
    var categories = EmojiProvider.categories
    var collectionView: UICollectionView!
    
    var searchBar: UISearchBar!
    var searching = false
    var searchEmoji = [Emoji]()
    
    var searchCategories: [EmojiCategory] {
        return EmojiProvider.categories(for: searchEmoji)
    }
    
    var selectEmojiDelegate: EmojiSelectDelegate!
    
    // MARK: - Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if searching {
            return searchCategories.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchCategories[section].emojis.count
        }
        return categories[section].emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
        
        var sectionData: EmojiCategory
        var emojisData: Emoji
        
        if searching {
            sectionData = searchCategories[indexPath.section]
            emojisData = sectionData.emojis[indexPath.row] }
        else {
            sectionData = categories[indexPath.section]
            emojisData = sectionData.emojis[indexPath.row] }
        

        cell.configure(with: emojisData.emoji)

        
        return cell
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var sectionData: EmojiCategory
        var emojisData: Emoji
        
        if searching {
            sectionData = searchCategories[indexPath.section]
            emojisData = sectionData.emojis[indexPath.row] }
        else {
            sectionData = categories[indexPath.section]
            emojisData = sectionData.emojis[indexPath.row] }
        
        selectEmojiDelegate.selectedEmoji(emojisData.emoji)
    }
    
    // MARK: Section Header View
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
        var category: String
        
        if searching {
            category = searchCategories[indexPath.section].name
        } else {
            category = categories[indexPath.section].name
        }
        
        sectionHeaderView.cagtegoryTitle = category
        return sectionHeaderView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension EmojiDataService: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchEmoji = EmojiProvider.emojis.filter({ (emoji) -> Bool in
            
            let descriptionMatch = emoji.description.range(of: searchText, options: .caseInsensitive)
            let aliasesMatch = emoji.aliases.first?.range(of: searchText, options: .caseInsensitive)
            
            return descriptionMatch != nil || aliasesMatch != nil
        })
        searching = searchText != "" ? true : false

        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    
}



