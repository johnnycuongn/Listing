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
    
    func addSubList(title: String, emoji: String)
    
    func deleteSubList(at index: Int)
    
    func moveSubList(from startIndex: Int, to endIndex: Int)
}
