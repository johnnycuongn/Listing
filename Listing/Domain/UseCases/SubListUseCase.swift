//
//  SubListUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol SubListUseCase {
    
    func loadSubList(completion: @escaping (Result<DomainSubList, Error>) -> Void)
    
    func addSubList(name: String, emoji: String?)
    func deleteSubList(at pos: Int)
    
    func moveSubList(from startPos: Int, to endPos: Int)
}
