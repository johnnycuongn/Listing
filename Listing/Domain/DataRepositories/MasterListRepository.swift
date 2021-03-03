//
//  MasterListRepository.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol MasterListRepository {
    
    func loadMasterList(completion: @escaping (Result<[DomainMasterList], Error>) -> Void)
    
    func addMasterList(title: String, emoji: String?)
    
    func deleteMasterList(at index: Int)
    
    func moveMasterList(from startIndex: Int, to endIndex: Int)
}
