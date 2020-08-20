//
//  VC+ItemInputTextView.swift
//  Listing
//
//  Created by Johnny on 27/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            if updatedText.isEmpty {
                resetToPlaceHolder()
            }

             else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.textColor = UIColor.white
                textView.text = text
                    if (text == "\n") && textView.text == "\n" {
                        textView.resignFirstResponder()
                        isKeyboardShowing = false
                        inputItemView.isHidden = true
                        return false
                    }
                textView.returnKeyType = .default
                textView.reloadInputViews()
            }
                
            else {
                if text == "\n" && textView.text != "" {
                    do {
                        try addNewItem(from: textView)
                            resetToPlaceHolder()
                    } catch {
                    }
                    return false
                }
                return true
            }
            return false
        }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func resetToPlaceHolder() {
        inputItemTextView.text = "Enter your item"
        inputItemTextView.textColor = UIColor.lightGray
    
        inputItemTextView.selectedTextRange = inputItemTextView.textRange(from: inputItemTextView.beginningOfDocument, to: inputItemTextView.beginningOfDocument)
        
        inputItemTextView.returnKeyType = .done
        inputItemTextView.reloadInputViews()
    }
    
}