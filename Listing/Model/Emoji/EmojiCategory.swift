//
//  EmojiCategory.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

struct EmojiCategory {
    var name: String
    var emojis: [Emoji]
}

extension EmojiProvider {
    
        static var categories: [EmojiCategory] {
            
            var emojiCategoryResult: [EmojiCategory] = suggestedEmojiCategory
            
            for category in EmojiProvider.categoryTypes {
                let newCategory = EmojiCategory(name: category, emojis: [])
                emojiCategoryResult.append(newCategory)
            }
            
            for emoji in EmojiProvider.emojis {
                for index in 0...emojiCategoryResult.count-1 {
                    if emoji.category == emojiCategoryResult[index].name {
                        emojiCategoryResult[index].emojis.append(emoji)
                    }
                }
                /// Count for each category
            }

            return emojiCategoryResult
        }
        
        static var categoryTypes: [String] {
            var result = [String]()
            
            for emoji in emojis {
                if !result.contains(emoji.category) {
                    result.append(emoji.category)
                }
            }
            
            return result
        }
}

