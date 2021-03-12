//
//  SubListRepository.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol SubListRepository {
    
    func loadSubList(completion: @escaping (Result<[DomainSubList], Error>) -> Void)
    
    func updateSubList(title: String, at index: Int)
    func updateSubList(emoji: String, at index: Int)
    
    func addSubList(title: String, emoji: String)
    
    func deleteSubList(at index: Int)
    
    func moveSubList(from startIndex: Int, to endIndex: Int)
}
