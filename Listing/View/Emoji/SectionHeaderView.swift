//
//  SectionHeaderView.swift
//  Listing
//
//  Created by Johnny on 16/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

import Foundation
import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    static var identifier = "SectionHeaderView"
    
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    var cagtegoryTitle: String! {
        didSet {
            categoryTitleLbl.text = cagtegoryTitle
        }
    }
    
    
    
    
}

