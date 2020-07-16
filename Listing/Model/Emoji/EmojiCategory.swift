//
//  EmojiCategory.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

extension EmojiProvider {
    
        static var categories: [EmojiCategory] {
            
            var result = [EmojiCategory]()
            
            for category in EmojiProvider.categoryTypes {
                let newCategory = EmojiCategory(name: category, emojis: [])
                result.append(newCategory)
            }
            
            for emoji in EmojiProvider.emojis {
                for index in 0...result.count-1 {
                    if emoji.category == result[index].name {
                        result[index].emojis.append(emoji.emoji)
                    }
                }
                /// Count for each category
            }
            
//            print(result)
            return result
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

