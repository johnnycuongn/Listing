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
}

struct EmojiCategory {

    var name: String
    var emojis: [String]
    
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

public extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

