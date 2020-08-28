//
//  ItemCell.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol SwipeItemToDeleteDelegate: UIGestureRecognizerDelegate {
    func isComplete(_ item: ItemCell) -> Bool
    func updateComplete(for item: ItemCell, with isComplete: Bool)
}

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    var titleLabelWidth: CGFloat?
    var titleLabelWordWidth: CGFloat?
    
    var isCompleted: Bool {
        get {
            return swipeToDeleteDelegate.isComplete(self)
        }
        set {
            swipeToDeleteDelegate.updateComplete(for: self, with: newValue)
        }
    }
    
    var swipeToDeleteDelegate: SwipeItemToDeleteDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.isUserInteractionEnabled = true
        selectionStyle = .none
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
        
        panRight.delegate = self
        
        titleLabel.addGestureRecognizer(panRight)
                
                
         if let font = UIFont(name: "HelveticaNeue-Light", size: 17) {
             let fontAttributes = [NSAttributedString.Key.font: font]
             let myText = titleLabel.text!
             let myWord = "a"
             titleLabelWidth = (myText as NSString).size(withAttributes: fontAttributes).width
             titleLabelWordWidth = (myWord as NSString).size(withAttributes: fontAttributes).width
         } else {
            print("Fatal")
             titleLabelWordWidth = 9
             titleLabelWidth = CGFloat(9 * titleLabel.text!.count)
         }
     }
    
    @objc func handlePanRight(recognizer: UIPanGestureRecognizer) {
        let xTranslation: CGFloat = recognizer.translation(in: self.contentView).x
        var endPoint: CGPoint = CGPoint(x: 0, y: 0)
        
        // USER did swipe right
        if xTranslation > 0 {
            switch recognizer.state {
            case .changed:
                if isCompleted == false {
                    titleLabel.attributedText = titleLabel.text!.strikeThrough(.add, translation: xTranslation/titleLabelWordWidth!)
                }
                else {
                    titleLabel.attributedText = titleLabel.text!.strikeThrough(.remove, translation: xTranslation/titleLabelWordWidth!)
                }
            case .ended:
                endPoint = recognizer.location(in: self.contentView)
                // IF there is no strikethrough
                // USER adding strikethrough (complete task)
                if isCompleted == false {
                    if xTranslation > titleLabelWidth!/2.7
                    || endPoint.x > contentView.frame.size.width / 1.5  {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.add)
                        isCompleted = true
                    } else {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.remove)
                        isCompleted = false
                    }
                }
                // IF there is strikethrough
                // USER removing strikethrough
                else {
                    if xTranslation > titleLabelWidth!/2.7
                    || endPoint.x > contentView.frame.size.width / 1.5 {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.remove)
                        isCompleted = false
                    } else {
                        titleLabel.attributedText = titleLabel.text?.strikeThrough(.add)
                        isCompleted = true
                    }
                }
           
            default:
                break
            }
        }
    }
}
