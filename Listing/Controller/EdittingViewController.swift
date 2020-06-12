//
//  EdittingViewController.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class EdittingViewController: UIViewController {


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var itemToEdit: Item? = nil
    var itemToEditIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemToEdit = itemToEdit {
            updateLabelForItemToEdit(itemToEdit)
        }
    }
    
//    @IBAction func textDidBegin(_ sender: Any) {
//        guard let title = titleTextField?.text else { fatalError() }
//        if itemToEdit == nil {
//            newItem = Item(title: title, description: descriptionTextView.text)
//        }
//        else {
//            itemToEdit = Item(title: title, description: descriptionTextView.text)
//        }
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
         // TODO:
        
        if segue.identifier == "saveItemSegue" {
            let title = titleTextField.text ?? "Empty"
            let description = descriptionTextView.text ?? ""
            self.itemToEdit = Item(title: title, description: description)
            }
    }
    
    func updateLabelForItemToEdit(_ item: Item) {
        titleTextField?.text = item.title
        descriptionTextView?.text = item.description
    }
    

}
