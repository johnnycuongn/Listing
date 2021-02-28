//
//  ItemUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol ItemUseCase {
    
    func loadItem(completion: @escaping (Result<DomainItem, Error>) -> Void)
    
    func addItem(name: String, emoji: String?)
    func deleteItem(at pos: Int)
    
    func moveItem(from startPos: Int, to endPos: Int)
}
