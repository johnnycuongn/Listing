//
//  StrikeThrough.swift
//  Listing
//
//  Created by Johnny on 27/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

enum StrikeThroughState {
    case add
    case remove
}

extension String {
    func strikeThrough(_ state: StrikeThroughState) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        switch state {
        case .add:
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        case .remove:
            attributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        }
        
        return attributedString
    }
}
