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
        editSubListTitle(true)
        
        listTitleButton.setTitle("", for: .normal)
        
        // Resign ItemTextView First Responder if it's currently assigned
        if inputItemTextView.isFirstResponder {
            controllerState.resetItemInput()
            inputItemTextView.resignFirstResponder()
        }
        
        listTitleTextField.becomeFirstResponder()
        listTitleTextField.returnKeyType = .default
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        resetInputTextView()
        
        inputItemToolbar.isHidden = false
        
        inputItemTextView.becomeFirstResponder()

    }
    
    @IBAction func navigateBackToMain(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Input item Toolbar
    @IBAction func closeItemInputView(_ sender: Any) {
        controllerState.resetItemInput()
        
        inputItemTextView.resignFirstResponder()
    }
    
    @IBAction func toolbarAddButtonTapped(_ sender: UIButton) {
        do {
            if controllerState.isEditingItem.value {
                try updateItem(from: inputItemTextView, at: controllerState.isEditingItem.index)
                controllerState.resetItemInput()
            }
            else {
                try addNewItem(from: inputItemTextView)
            }
                resetInputTextView()
        } catch {
        }
    }
}
