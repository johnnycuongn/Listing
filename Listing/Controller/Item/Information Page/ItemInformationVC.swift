//
//  ItemInformationVC.swift
//  Listing
//
//  Created by Johnny on 10/9/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ItemInformationVC: UIViewController, UITextViewDelegate {
    
    var selectedItem: Item!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var taskTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTextView.delegate = self
        taskTextView.keyboardDismissMode = .interactive
        taskTextView.returnKeyType = .default
        
        taskTextView.text = selectedItem.title
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            selectedItem.updateTitle(with: taskTextView.text)
            taskTextView.resignFirstResponder()
        }
        
        return true
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        selectedItem.updateTitle(with: taskTextView.text)
        taskTextView.resignFirstResponder()
    }
}
