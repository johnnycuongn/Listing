//
//  ViewController.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit
import Foundation

enum ListVCError: Error {
    case emptyText
}

public enum Segues {
    static let saveEmoji = "saveEmoji"
}

class ListViewController: UIViewController, UITextFieldDelegate {
    
    /// - Systems
    @IBOutlet weak var emojiButton: UIButton!
    
    @IBOutlet weak var listTitleButton: UIButton!
    @IBOutlet weak var listTitleTextField: UITextField!
    
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ListTableViewDataService!
    @IBOutlet var inputTextFieldHandler: InputItemTextFieldHander!
    /// - Time Labels
    @IBOutlet weak var hourLeftLabel: UILabel!
    @IBOutlet weak var minuteLeftLabel: UILabel!
    /// - Buttons Outlets
    @IBOutlet weak var addButton: UIButton!
    /// - Input Item Outlets
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var inputItemTextField: UITextField!
    @IBOutlet weak var inputItemView: UIStackView!
    
    /// - Variables
    var listManager = ListOfItemManager()

    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //// Delegate and datasource
        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        dataService.listManager = self.listManager
        
        self.inputItemTextField.delegate = self
        self.listTitleTextField.delegate = self
//        textFieldHandler.listManager = self.listManager

        
        ////Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
        loadData()
        
        ////View
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        inputItemView.isHidden = true
        
//        view.overrideUserInterfaceStyle = .light

        ////Timer
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ListViewController.updateTimeLabel), userInfo: nil, repeats: true)
        
        
    }
    
    // MARK: - Actions
    
    
    @IBAction func listTitleButtonTapped(_ sender: Any) {
        listTitleTextField.text = listTitleButton.titleLabel!.text
        listTitleTextField.isHidden = false
        listTitleButton.isHidden = true
        listTitleButton.setTitle("", for: .normal)
        listTitleTextField.becomeFirstResponder()
        listTitleTextField.returnKeyType = .default
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        resetInputTextField(with: inputItemTextField)

        addItemButton.isHidden = true
        inputItemView.isHidden = !inputItemView.isHidden
        
        inputItemTextField.becomeFirstResponder()
    }
    
    // MARK: - Input Item Actions
    
    @IBAction func textFieldEdittingDidBegin(_ sender: UITextField) {
        if sender == inputItemTextField {
            inputItemTextField.returnKeyType = .done
        }
        if sender == listTitleTextField {
            listTitleTextField.returnKeyType = .default
        }
        
    }
    
    @IBAction func textFieldEdittingChanged(_ sender: UITextField) {
        if sender == inputItemTextField {
            addItemButton.isHidden = !inputItemTextField.hasText
            inputItemTextField.returnKeyType = inputItemTextField.text == "" ? .done : .default
            inputItemTextField.reloadInputViews()
        }
        
        if sender == listTitleTextField {
//            listTitleTextField.returnKeyType = listTitleTextField.text == "" ? .done : .default
        }

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputItemTextField {
            do { try addNewItem(from: textField) }
            catch ListVCError.emptyText {
                if inputItemTextField.returnKeyType == .done {
                    closeKeyboard(with: textField)
                }
            }
            catch {}

        }
        if textField == listTitleTextField {
            guard listTitleTextField.text != "" else {
                listTitleTextField.attributedPlaceholder = NSAttributedString(string: "Enter your item", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                return false
            }
            listTitleButton.setTitle(listTitleTextField.text, for: .normal)
            listTitleTextField.isHidden = true
            listTitleButton.isHidden = false
           
            
            closeKeyboard(with: textField)
        }
        
        return true
    }
    
    
    @IBAction func addItemButton(_ sender: UIButton) {
        do { try addNewItem(from: inputItemTextField) }
        catch ListVCError.emptyText {
            inputItemTextField.attributedPlaceholder = NSAttributedString(string: "Enter your item", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        catch {}
    }

    @IBAction func closeTextField(_ sender: Any) {
        closeKeyboard(with: inputItemTextField)
        print(listManager.newList)
    }
    
    
    // MARK: - Convenience methods
    
    // MARK: Model
    func loadData() {
        listManager.itemsInList = DataManager.loadAll(from: Item.self).sorted { (item1, item2) -> Bool in
            item1.index < item2.index
            }
        
        listTableView.reloadData()
    }
    
    // MARK: View
    @objc func updateTimeLabel() {
        let today = Date() ; let tomorrow = Date(timeIntervalSinceNow: 86400)
        let startOfTomorrow = Calendar.current.startOfDay(for: tomorrow)
        let timeUntilTomorrow = today.distance(to: startOfTomorrow)

            let timeLeft = timeUntilTomorrow.convertToHourMinutes()
            self.hourLeftLabel.text = "\(timeLeft.hour)"
            self.minuteLeftLabel.text = "\(timeLeft.minutes)"
    }
    
    func closeKeyboard(with textField: UITextField) {
        if textField == inputItemTextField {
            inputItemView.isHidden = true
        }
        textField.resignFirstResponder()
    }
    
    // MARK: Action
    func addNewItem(from textField: UITextField) throws {
        guard textField.text != "" else {
            throw ListVCError.emptyText
        }
        
        let newItem = Item(title: textField.text!, index: 0, itemIdentifier: UUID())
        listManager.addItemAtTop(newItem)
        listTableView.reloadData()
        
        resetInputTextField(with: textField)
    }
    
    func resetInputTextField(with textField: UITextField) {
        if textField == inputItemTextField {
            inputItemTextField.text = ""
            inputItemTextField.returnKeyType = .done
        }
        
//        inputItemTextField.attributedPlaceholder = NSAttributedString(string: "Enter your item", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        inputItemTextField.reloadInputViews()
        
    }
    
    
    
    // MARK: - Old Segues Code to EditVC
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetailsVC" {
//            guard let edittingVC = segue.destination as? EdittingViewController else { return }
//            let indexPath = listTableView.indexPathForSelectedRow!
//
//            edittingVC.itemToEdit = listManager.itemAtIndex(indexPath.row)
//            edittingVC.itemToEditIndexPath = indexPath
//        }
//
//    }
    
    @IBAction func unwindToListViewController(segue: UIStoryboardSegue) {

//        guard segue.identifier == "saveItemSegue" else { return }
//
//        let edittingVC = segue.source as! EdittingViewController
//        guard let edittingItem = edittingVC.itemToEdit else { return }
//
//        if edittingVC.itemToEditIndexPath != nil {
//                print("Editing Item: \(edittingItem.title)")
//                let edittingIndexPath = edittingVC.itemToEditIndexPath!
//
//                listManager.changeItem(edittingItem, at: edittingIndexPath.row)
//
//                listTableView.reloadData()
//            }
//        else {
//                listManager.addItem(edittingItem)
//
//                listTableView.reloadData()
//            }
        
        guard segue.identifier == Segues.saveEmoji else { return }
        
        let emojiPageVC = segue.source as! EmojiPageViewController
        print("From List VC: \(emojiPageVC.selectedEmoji)")
        guard emojiPageVC.selectedEmoji != nil else { return }
        
        emojiButton.setTitle(emojiPageVC.selectedEmoji, for: .normal)
        
        print("Button: \(emojiButton.titleLabel?.text)")
    }
        
        

}


