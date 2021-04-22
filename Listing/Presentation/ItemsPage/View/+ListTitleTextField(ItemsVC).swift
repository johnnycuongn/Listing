//
//  +ListTitleTextField.swift
//  Listing
//
//  Created by Johnny on 27/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController: UITextFieldDelegate {
    
    @IBAction func textFieldEdittingDidBegin(_ sender: UITextField) {
        if sender == listTitleTextField {
            controllerState.isKeyboardShowing = true
            listTitleTextField.returnKeyType = .default
        }
    }
    
    @IBAction func textFieldEdittingChanged(_ sender: UITextField) {
        if sender == listTitleTextField {
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == listTitleTextField {
            guard listTitleTextField.text != "" else {
                listTitleTextField.attributedPlaceholder = NSAttributedString(string: "Untitled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                return false
            }
            
            pageViewModel.updateSublist(title: listTitleTextField.text!, at: subListCurrentIndex)
            
            setSubListView(title: listTitleTextField.text)
            editSubListTitle(false)
            
            listsThumbnailCollectionView.reloadData()
            
            if controllerState.isCreatingList == true {
                
                 var layout: UICollectionViewFlowLayout {
                       return self.listsThumbnailCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                   }
                
                listsThumbnailCollectionView.contentOffset.x = listsThumbnailCollectionView.frame.size.height*CGFloat(pageViewModel.subLists.value.count-1)+layout.minimumLineSpacing*CGFloat(pageViewModel.subLists.value.count-1)
            }
            
            controllerState.isCreatingList = false
            controllerState.isKeyboardShowing = false
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == listTitleTextField {
                let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count < 25
        }
        
        return true
    }
}
