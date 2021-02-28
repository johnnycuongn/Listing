//
//  MasterListUseCase.swift
//  Listing
//
//  Created by Johnny on 26/2/21.
//  Copyright © 2021 Johnny. All rights reserved.
//

import Foundation

protocol MasterListUseCase {
    
    func loadMasterList(completion: @escaping (Result<DomainMasterList, Error>) -> Void)
    
    func addMasterList(name: String)
    func deleteMasterList(at pos: Int)
    
    func moveMasterList(from startPos: Int, to endPos: Int)
    
}
