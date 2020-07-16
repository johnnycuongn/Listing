//
//  EmojiProvider.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class EmojiProvider {
    
    static var emojis: [Emoji] {
        return loadData()
    }
    
    // MARK: Fetch from local documentary
    
    static func loadData() -> [Emoji] {
        
        var tempEmojis = [Emoji]()
        
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Emojis.json")
        
        let baseURL = Bundle.main.url(forResource: "Emojis", withExtension: "json")
        do {
            guard let baseURL = baseURL else { fatalError() }
            
            if !fileManager.fileExists(atPath: documentURL.path) {
                try fileManager.copyItem(at: baseURL, to: documentURL)
            }
            
            let jsonDecoder = JSONDecoder()
            
            if let data = fileManager.contents(atPath: documentURL.path) {
                tempEmojis = try jsonDecoder.decode([Emoji].self, from: data)
            }
            
            
        }
        catch {
            fatalError(error.localizedDescription)
        }
//        print(tempEmojis)
        
        return tempEmojis
        
    }
    
    // MARK: Fetch from web
    
    
//    func fetchEmoji(completionHandler: @escaping ([Emoji]?) -> Void) {
////  https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json
//    let baseURL = URL(string:
//        "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json")!
//
//    let
//    task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
//
//        let jsonDecoder = JSONDecoder()
//
//        guard let data = data
//        else {
//            fatalError()
//        }
//
//        do {
//            let emojisData = try jsonDecoder.decode([Emoji].self, from: data)
//            completionHandler(emojisData)
//
//        } catch {
//            print(error.localizedDescription)
//            fatalError()
//        }
//    }
//    task.resume()
//
//    }
//
//    func fetch() {
//
//        var emojisFetch: [Emoji] = []
//
//        fetchEmoji { (emojisData) in
//            guard let emojisData = emojisData else {
//                fatalError("Oh no")
//            }
//            DispatchQueue.main.async {
//                emojisFetch = emojisData
//                print("First: \(emojisFetch.count)")
//                self.emojis = emojisFetch
//            }
//
//        print(emojisFetch)
//
//        }
//        print("Second: \(emojisFetch.count)")
//    }
    
    
}
