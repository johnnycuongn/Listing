//
//  Emoji.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

struct Emoji: Codable {
    
    var emoji: String
    var description: String
    var category: String
    var aliases: [String]
    var tags: [String]
    
//    var unicodeVersion: Double
//    var iosVersion: Double
    
    enum CodingKeys: String, CodingKey {
        case emoji
        case description
        case category
        case aliases
        case tags
//        case unicodeVersion = "unicode_version"
//        case iosVersion = "ios_version"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.emoji = try valueContainer.decode(String.self, forKey: .emoji)
        self.description = try valueContainer.decode(String.self, forKey: .description)
        self.category = try valueContainer.decode(String.self, forKey: .category)
        self.aliases = try valueContainer.decode([String].self, forKey: .aliases)
        self.tags = try valueContainer.decode([String].self, forKey: .tags)
//
//        self.unicodeVersion = try valueContainer.decode(Double.self, forKey: CodingKeys.unicodeVersion)
//        self.iosVersion = try valueContainer.decode(Double.self, forKey: .iosVersion)
    }
    
    init(emoji: String, description: String, category: String, aliases: [String], tags: [String]) {
        self.emoji = emoji
        self.description = description
        self.category = category
        self.aliases = aliases
        self.tags = tags
    }
}



