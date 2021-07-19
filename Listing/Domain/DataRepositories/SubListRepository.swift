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
    
    func updateSubList(title: String, at index: Int, completion: @escaping (Bool, Error?) -> Void)
    func updateSubList(emoji: String, at index: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func addSubList(title: String, emoji: String, completion: @escaping (Bool, Error?) -> Void)
    
    func deleteSubList(at index: Int, completion: @escaping (Bool, Error?) -> Void)
    
    func moveSubList(from startIndex: Int, to endIndex: Int, completion: @escaping (Bool, Error?) -> Void)
}
