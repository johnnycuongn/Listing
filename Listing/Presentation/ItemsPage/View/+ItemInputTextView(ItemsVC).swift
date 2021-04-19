//
//  VC+ItemInputTextView.swift
//  Listing
//
//  Created by Johnny on 27/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            if updatedText.isEmpty {
                resetInputTextView()
            }
        // When user start to type
             else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                
                textView.textColor = UIColor.white
                textView.text = text
                    // When user tapped done (no text)
                    if (text == "\n") && textView.text == "\n" {
                        textView.resignFirstResponder()
                        controllerState.isKeyboardShowing = false
                        
                        return false
                    }
                textView.returnKeyType = .default
                textView.reloadInputViews()
            }
                
            else {
                if text == "\n" && textView.text != "" {
                    do {
                        if controllerState.isUpdatingItem.value {
                            try updateItem(from: inputItemTextView, at: controllerState.isUpdatingItem.index)
                            controllerState.isUpdatingItem = (false, -1)
                        }
                        else {
                            try addNewItem(from: inputItemTextView)
                        }
                            resetInputTextView()
                    } catch {
                    }
                    return false
                }
                return true
            }
            return false
        }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if (self.view.window != nil) && (textView.textColor == UIColor.lightGray) {
                textView.selectedTextRange = textView.textRange(
                    from: textView.beginningOfDocument,
                    to: textView.beginningOfDocument)
        } else {
            textView.selectedTextRange = textView.textRange(
                from: textView.endOfDocument,
                to: textView.endOfDocument)
        }
    }
    
    func resetInputTextView(isEditing: Bool = false) {
        if isEditing {
            // Set for editting item
            inputItemTextView.textColor = UIColor.white
            inputItemTextView.selectedTextRange = inputItemTextView.textRange(
                from: inputItemTextView.endOfDocument,
                to: inputItemTextView.endOfDocument)
        } else {
            // Set placeholder
            inputItemTextView.text = "Enter your item"
            inputItemTextView.textColor = UIColor.lightGray
            
            inputItemTextView.selectedTextRange = inputItemTextView.textRange(
                from: inputItemTextView.beginningOfDocument,
                to: inputItemTextView.beginningOfDocument)
        }
    
        
        
        // Set keyboard attributes
        inputItemTextView.returnKeyType = .done
        inputItemTextView.reloadInputViews()
        
    }
    
}
