//
//  ItemRepository.swift
//  Listing
//
//  Created by Johnny on 7/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol ItemRepository {
    
    func loadItem(completion: @escaping (Result<[DomainItem], Error>) -> Void)

    func addItem(title: String, from pos: Direction, completion: @escaping (Bool, Error?) -> Void)
    
    func setItemCompletion(at index: Int, _ value: Bool, completion: @escaping (Bool, Error?) -> Void)
    
    func insertItem(title: String, at insertedPos: Int, completion: @escaping (Bool, Error?) -> Void)

    func deleteItem(at index: Int, completion: @escaping (Bool, Error?) -> Void)

    func moveItem(from startIndex: Int, to endIndex: Int, completion: @escaping (Bool, Error?) -> Void)
}

