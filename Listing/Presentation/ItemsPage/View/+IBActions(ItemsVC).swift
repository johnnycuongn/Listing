//
//  + IBActions.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension ItemsViewController {
    // MARK: Main
    @IBAction func listTitleButtonTapped(_ sender: Any) {
        listTitleTextField.text = listTitleButton.titleLabel!.text
        setHidden(listTitleTextField: false)
        
        listTitleButton.setTitle("", for: .normal)
        
        listTitleTextField.becomeFirstResponder()
        listTitleTextField.returnKeyType = .default
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        resetInputTextView()
        
        controllerState.isAddButtonTapped = true
        
        inputItemToolbar.isHidden = false
        
        inputItemTextView.becomeFirstResponder()
        controllerState.isKeyboardShowing = true
    }
    
    @IBAction func navigateBackToMain(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Input item Toolbar
    @IBAction func closeItemInputView(_ sender: Any) {
        controllerState.isEditingItem = (false, -1)
        
        inputItemTextView.resignFirstResponder()
    }
    
    @IBAction func toolbarAddButtonTapped(_ sender: UIButton) {
        do {
            if controllerState.isEditingItem.value {
                try updateItem(from: inputItemTextView, at: controllerState.isEditingItem.index)
                controllerState.isEditingItem = (false, -1)
            }
            else {
                try addNewItem(from: inputItemTextView)
            }
                resetInputTextView()
        } catch {
        }
    }
}
