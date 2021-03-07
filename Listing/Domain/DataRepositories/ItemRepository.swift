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

    func addItem(title: String, from pos: Direction)
    
    func setItemCompletion(at index: Int, _ value: Bool)

    func deleteItem(at index: Int)

    func moveItem(from startIndex: Int, to endIndex: Int)
}

