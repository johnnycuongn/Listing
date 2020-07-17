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
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ListTableViewDataService!
    
    @IBOutlet weak var listsThumbnailCollectionView: UICollectionView!
    @IBOutlet var listsThumbnailCollectionViewDataService: ListsThumbnailCollectionViewDataService!
    
    @IBOutlet var inputTextFieldHandler: InputItemTextFieldHander!
    
    /// - List's Emoji and Title
    @IBOutlet weak var emojiButton: UIButton!
    
    @IBOutlet weak var listTitleButton: UIButton!
    @IBOutlet weak var listTitleTextField: UITextField!
    
    /// - Time Labels
    @IBOutlet weak var hourLeftLabel: UILabel!
    @IBOutlet weak var minuteLeftLabel: UILabel!
    /// - View's Buttons Outlets
    @IBOutlet weak var addButton: UIButton!
    /// - Input Item Outlets
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var inputItemTextField: UITextField!
    @IBOutlet weak var inputItemView: UIStackView!
    
    /// - Model Variables
    var listIndex = 0 {
        didSet {
            listTableViewDataUpdate()
            listViewUpdate(emoji: currentList.emoji, title: currentList.title)
        }
    }
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
        loadList()

        //// Delegate and datasource
        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        
        listsThumbnailCollectionView.dataSource = listsThumbnailCollectionViewDataService
        listsThumbnailCollectionView.delegate = listsThumbnailCollectionViewDataService
 
        self.inputItemTextField.delegate = self
        self.listTitleTextField.delegate = self
        
        
         listsThumbnailCollectionViewDataUpdate()
         listTableViewDataUpdate()
        
        ////List Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
     
        ////View
        listsThumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: listsThumbnailCollectionView.frame.size.width-ListsThumbnailCollectionViewCell.width*3-11)
        
        listViewUpdate(emoji: currentList.emoji, title: currentList.title)
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        inputItemView.isHidden = true

        ////Timer
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ListViewController.updateTimeLabel), userInfo: nil, repeats: true)
        
        
    }
    
    // MARK: - Actions
    
    
    @IBAction func listTitleButtonTapped(_ sender: Any) {
        listTitleTextField.text = listTitleButton.titleLabel!.text
        setHidden(listTitle: true, textField: false)
        
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
            
            currentList.title = listTitleTextField.text!
            
            listViewUpdate(title: listTitleTextField.text)
            setHidden(listTitle: false, textField: true)
           
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
    func loadList() {
        
        listsManager.lists = DataManager.loadAll(from: List.self)
        
        if listsManager.lists.isEmpty {
            listsManager.lists = [
            List(emoji: "💼", title: "Welcome", items: [
                Item(title: "Tap to Delete")
            ]),
            List(emoji: "🤥", title: "Welcome Second", items: [
                Item(title: "Tap To Delete Now")
            ])
            ]
            
            for index in 0...listsManager.lists.count-1 {
                listsManager.lists[index].saveList()
            }
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
    
    func listsThumbnailCollectionViewDataUpdate() {
        listsThumbnailCollectionViewDataService.listManager = self.listsManager
        listsThumbnailCollectionViewDataService.listIndex = self.listIndex
        listsThumbnailCollectionViewDataService.collectionView = listsThumbnailCollectionView
        listsThumbnailCollectionViewDataService.thumbnailUpdateService = self
    }
    
    func listTableViewDataUpdate() {
        dataService.listsManager = self.listsManager
        dataService.listIndex = self.listIndex
    }
    
    func listViewUpdate(emoji: String? = nil, title: String? = nil) {
        if emoji != nil {
            emojiButton.setTitle(emoji, for: .normal) }
        if title != nil {
            listTitleButton.setTitle(title, for: .normal) }
        
        listTableView.reloadData()
    }
    
    func setHidden(listTitle: Bool, textField: Bool) {

        self.listTitleButton.isHidden = listTitle
        self.listTitleTextField.isHidden = textField
        
    }
    
    // MARK: Actions
    func addNewItem(from textField: UITextField) throws {
        guard textField.text != "" else {
            throw ListVCError.emptyText
        }
        
        let newItem = Item(title: textField.text!)
        self.currentList.addItemAtTop(newItem)

        listTableView.reloadData()
        
        resetInputTextField(with: textField)
    }
    
    func resetInputTextField(with textField: UITextField) {
        if textField == inputItemTextField {
            inputItemTextField.text = ""
            inputItemTextField.returnKeyType = .done
        }
        
        inputItemTextField.reloadInputViews()
        
    }
    
    
    // MARK: - Segues
    
    @IBAction func unwindToListViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == Segues.saveEmoji else { return }
        
        let emojiPageVC = segue.source as! EmojiPageViewController
 
        guard emojiPageVC.selectedEmoji != nil else { return }
        
        self.currentList.emoji = emojiPageVC.selectedEmoji!
        emojiButton.setTitle(emojiPageVC.selectedEmoji, for: .normal)
        
        listsThumbnailCollectionView.reloadData()
    }

    
    func updateThumbnail(from offset: Double) {
        
        let cellWidth = Double(ListsThumbnailCollectionViewCell.width)
                     
            if Int(offset/cellWidth) <= listsManager.lists.count-1 && offset > 0 {
                    listIndex = Int(offset/cellWidth)
            } else if Int(offset/cellWidth) >= listsManager.lists.count {
                    listIndex = listsManager.lists.count-1
            } else if Int(offset/cellWidth) <= 0 {
                    listIndex = 0
            }
            
            listTableView.reloadData()

        }
    
}


