//
//  ItemCell.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol SwipeItemToDeleteDelegate {
    func isComplete(_ item: ItemCell) -> Bool
    func updateComplete(for item: ItemCell, with isComplete: Bool)
}

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    var titleLabelWidth: CGFloat?
    var titleLabelWordWidth: CGFloat?
    
    var isCompleted: Bool {
        get {
            swipeToDeleteDelegate.isComplete(self)
        }
        set {
            swipeToDeleteDelegate.updateComplete(for: self, with: newValue)
        }
    }
    
    var swipeToDeleteDelegate: SwipeItemToDeleteDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(item: Item) {
        
        self.titleLabel.attributedText = item.title!.strikeThrough(.remove)
        
        
        if item.isCompleted == true {
            self.titleLabel.attributedText = item.title!.strikeThrough(.add)
        }
        
        setUpPanRight()
    }
}

    // MARK: Pan Recognizer
extension ItemCell {
    func setUpPanRight() {
         let panRight = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanRight(recognizer:)))
                
         titleLabel.addGestureRecognizer(panRight)
         titleLabel.isUserInteractionEnabled = true
                
                
         if let font = UIFont(name: "System Light", size: 17) {
             let fontAttributes = [NSAttributedString.Key.font: font]
             let myText = titleLabel.text!
             let myWord = "a"
             titleLabelWidth = (myText as NSString).size(withAttributes: fontAttributes).width
             titleLabelWordWidth = (myWord as NSString).size(withAttributes: fontAttributes).width
         } else {
             titleLabelWordWidth = 9
             titleLabelWidth = CGFloat(9 * titleLabel.text!.count)
         }
     }
    
    @objc func handlePanRight(recognizer: UIPanGestureRecognizer) {
        let xTranslation: CGFloat = recognizer.translation(in: self.contentView).x
        var startPoint: CGPoint = CGPoint(x: 0, y: 0)
              
        switch recognizer.state {
        case .began:
            startPoint = recognizer.location(in: self.contentView)
        case .changed:
            if xTranslation > startPoint.x {
                if isCompleted == false {
                    titleLabel.attributedText = titleLabel.text!.strikeThrough(.add, translation: xTranslation/titleLabelWordWidth!)
                }
                else {
                    titleLabel.attributedText = titleLabel.text!.strikeThrough(.remove, translation: xTranslation/titleLabelWordWidth!)
                }
            }
              
        case .ended:
                  
            if xTranslation > startPoint.x {
                if isCompleted == false {
                    if xTranslation > titleLabelWidth!/2 {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.add)
                        isCompleted = true
                    } else {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.remove)
                        isCompleted = false
                }
            }
            else {
                if xTranslation < titleLabelWidth!/2 {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.add)
                        isCompleted = true
                } else {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.remove)
                        isCompleted = false
                    }
                }
            }
            print("isDelete: \(isCompleted)")
        default:
            break
        }
              
    }
}
