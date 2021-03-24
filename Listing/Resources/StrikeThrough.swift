//
//  StrikeThrough.swift
//  Listing
//
//  Created by Johnny on 27/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

enum StrikeThroughState {
    case add
    case remove
}

extension String {
    func strikeThrough(_ state: StrikeThroughState, translation: CGFloat? = nil ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        // Translation / User tap
        if let translation = translation,
               translation <= CGFloat(attributedString.length),
               translation > 0 {
            switch state {
            case .add:
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, Int(translation)))
                
            case .remove:
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: Int(translation), length: attributedString.length-Int(translation)))
            }
        }
        else {
            // When there is no translation
            switch state {
            case .add:
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            case .remove:
                attributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
            }
        }
        
        return attributedString
    }
}

extension NSSet {
    func toArray<T>() -> [T] {
        return self.map { $0 as! T }
    }
}
