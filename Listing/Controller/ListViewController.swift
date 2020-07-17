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
    static let listsThumbnail = "ListsThumbnailCollectionView"
}

class ListViewController: UIViewController, UITextFieldDelegate, ThumbnailUpdatable {
    
    /// - Systems
    @IBOutlet weak var emojiButton: UIButton!
    
    @IBOutlet weak var listTitleButton: UIButton!
    @IBOutlet weak var listTitleTextField: UITextField!
    
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ListTableViewDataService!
    
    @IBOutlet weak var listsThumbnailCollectionView: UICollectionView!
    @IBOutlet var listsThumbnailCollectionViewDataService: ListsThumbnailCollectionViewDataService!
    
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
    var listIndex = 0
    var listsManager = ListsManager()
    
    var currentList: List {
        get {
            return listsManager.lists[listIndex]
        }
    }

    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ////    Data
        loadData()

        //// Delegate and datasource
        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        
        dataService.listsManager = self.listsManager
        dataService.listIndex = self.listIndex
        
        listsThumbnailCollectionView.dataSource = listsThumbnailCollectionViewDataService
        listsThumbnailCollectionView.delegate = listsThumbnailCollectionViewDataService
        
        listsThumbnailCollectionViewDataService.listManager = self.listsManager
        listsThumbnailCollectionViewDataService.listIndex = self.listIndex
        
        self.inputItemTextField.delegate = self
        self.listTitleTextField.delegate = self
        
        
        ////Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
     
        ////View
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        inputItemView.isHidden = true
        
        listTitleButton.setTitle(currentList.title, for: .normal)
        emojiButton.setTitle(currentList.emoji, for: .normal)
        
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
        }

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputItemTextField {
            do {
                try addNewItem(from: textField)
            }
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
            currentList.title = listTitleTextField.text!
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
    }
    
    
    // MARK: - Convenience methods
    
    // MARK: Model
    func loadData() {
        
        listsManager.lists = DataManager.loadAll(from: List.self)
        
        if listsManager.lists.isEmpty {
            listsManager.lists = [
            List(emoji: "💼", title: "Welcome", items: [
                Item(title: "Tap to Delete")
            ])
            ]
            
            listsManager.lists[0].saveList()
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
        
        let newItem = Item(title: textField.text!)
        self.currentList.addItemAtTop(newItem)
//        listManager.addItemAtTop(newItem)
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
 
        guard emojiPageVC.selectedEmoji != nil else { return }
        
        self.currentList.emoji = emojiPageVC.selectedEmoji!
        emojiButton.setTitle(emojiPageVC.selectedEmoji, for: .normal)
        
        listsThumbnailCollectionView.reloadData()
    }

    
    func updateThumbnail(from offset: Double) {
                     
            if Int(offset/55) <= listsManager.lists.count-1 && offset > 0 {
                    listIndex = Int(offset/55)
            } else if Int(offset/55) >= listsManager.lists.count {
                    listIndex = listsManager.lists.count-1
            } else if Int(offset/55) <= 0 {
                    listIndex = 0
            }
            
    //        print("index: \(listIndex)")
            listTableView.reloadData()

        }
    
}


