//
//  EmojiSuggestion.swift
//  Listing
//
//  Created by Johnny on 23/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

extension EmojiProvider {
    static var suggestedEmojiCategory: [EmojiCategory] = [
        EmojiCategory(name: "Home", emojis: [
            Emoji(emoji: "🏠", description: "house", category: "Travel & Places", aliases: ["house"], tags: []),
            Emoji(emoji: "🌦️", description: "sun behind rain cloud", category: "Travel & Places", aliases: ["sun_behind_rain_cloud"], tags: []),
            Emoji(emoji: "🍽️", description: "fork and knife with plate", category: "Food & Drink", aliases: ["plate_with_cutlery"], tags: ["dining", "dinner"]),
            Emoji(emoji: "🛒", description: "shopping cart", category: "Objects", aliases: ["shopping_cart"], tags: []),
            Emoji(emoji: "📆", description: "tear-off calendar", category: "Objects", aliases: ["calendar"], tags: ["schedule"]),
            Emoji(emoji: "🗓️", description: "spiral calendar", category: "Objects", aliases: ["spiral_calendar"], tags: []),
            Emoji(emoji: "🏠", description: "house", category: "Travel & Places", aliases: ["house"], tags: [])
        ]),
        EmojiCategory(name: "Personal & Work", emojis: [
            
            Emoji(emoji: "💭", description: "thought balloon", category: "Smileys & Emotion", aliases: ["thought_balloon"], tags: ["thinking"]),
            Emoji(emoji: "🧭", description: "compass", category: "Travel & Places", aliases: ["compass"], tags: []),
            Emoji(emoji: "💡", description: "light bulb", category: "Objects", aliases: ["bulb"], tags: ["idea", "light"]),
            Emoji(emoji: "📅", description: "calendar", category: "Objects", aliases: ["date"], tags: ["calendar", "schedule"]),
            Emoji(emoji: "📚", description: "books", category: "Objects", aliases: ["books"], tags: ["library"]),
            Emoji(emoji: "📖", description: "open book", category: "Objects", aliases: ["book", "open_book"], tags: []),
            Emoji(emoji: "📋", description: "clipboard", category: "Objects", aliases: ["clipboard"], tags: []),
            Emoji(emoji: "📃", description: "page with curl", category: "Objects", aliases: ["page_with_curl"], tags: []),
            Emoji(emoji: "📄", description: "page facing up", category: "Objects", aliases: ["page_facing_up"], tags: ["document"]),
            Emoji(emoji: "🗒️", description: "spiral notepad", category: "Objects", aliases: ["spiral_notepad"], tags: []),
            Emoji(emoji: "📝", description: "memo", category: "Objects", aliases: ["memo", "pencil"], tags: ["document", "note"]),
            Emoji(emoji: "📩", description: "envelope with arrow", category: "Objects", aliases: ["envelope_with_arrow"], tags: []),
            Emoji(emoji: "💼", description: "briefcase", category: "Objects", aliases: ["briefcase"], tags: ["business"]),
            Emoji(emoji: "📁", description: "file folder", category: "Objects", aliases: ["file_folder"], tags: ["directory"]),
            Emoji(emoji: "📊", description: "bar chart", category: "Objects", aliases: ["bar_chart"], tags: ["stats", "metrics"]),
            Emoji(emoji: "📌", description: "pushpin", category: "Objects", aliases: ["pushpin"], tags: ["location"]),
            Emoji(emoji: "📍", description: "round pushpin", category: "Objects", aliases: ["round_pushpin"], tags: ["location"]),
            Emoji(emoji: "📎", description: "paperclip", category: "Objects", aliases: ["paperclip"], tags: []),
            Emoji(emoji: "🖇️", description: "linked paperclips", category: "Objects", aliases: ["paperclips"], tags: []),
            Emoji(emoji: "🗑️", description: "wastebasket", category: "Objects", aliases: ["wastebasket"], tags: ["trash"])
            
        ])
//        , EmojiCategory(name: "Medicine", emojis: [
//            Emoji(emoji: "🥼", description: "lab coat", category: "Objects", aliases: ["lab_coat"], tags: []),
//            Emoji(emoji: "🔬", description: "microscope", category: "Objects", aliases: ["microscope"], tags: ["science", "laboratory", "investigate"]),
//
//             Emoji(emoji: "⚗️", description: "alembic", category: "Objects", aliases: ["alembic"], tags: []),
//
//            Emoji(emoji: "🧪", description: "test tube", category: "Objects", aliases: ["test_tube"], tags: []),
//
//            Emoji(emoji: "🧬", description: "dna", category: "Objects", aliases: ["dna"], tags: []),
//
//            Emoji(emoji: "💊", description: "pill", category: "Objects", aliases: ["pill"], tags: ["health", "medicine"]),
//
//            Emoji(emoji: "🩺", description: "stethoscope", category: "Objects", aliases: ["stethoscope"], tags: []),
//
//            Emoji(emoji: "💉", description: "syringe", category: "Objects", aliases: ["syringe"], tags: ["health", "hospital", "needle"]),
//
//            Emoji(emoji: "🩸", description: "drop of blood", category: "Objects", aliases: ["drop_of_blood"], tags: []),
//
//            Emoji(emoji: "🩹", description: "adhesive bandage", category: "Objects", aliases: ["adhesive_bandage"], tags: [])
//
//
//        ])
    ]
    
}
