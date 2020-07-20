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
    static let selectedList = "selectedFromListsTableView"
    static let toListsTableView = "toListsTableView"
}

class ListViewController: UIViewController, UITextViewDelegate, ListUpdatable, PullDownToAddable, UITextFieldDelegate {
    
    /// - Systems
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ListTableViewDataService!
    
    @IBOutlet weak var listsThumbnailCollectionView: UICollectionView!
    @IBOutlet var listsThumbnailCollectionViewDataService: ListsThumbnailCollectionViewDataService!
    
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
    @IBOutlet weak var inputItemTextView: UITextView!
    @IBOutlet weak var inputItemView: UIStackView!
    
    /// - Model Variables
    var listIndex = 0 {
        didSet {
            /// Stop listTableView load too much when list thumbnail is scrolling
            if (listsThumbnailCollectionView.isDragging || listsThumbnailCollectionView.isDecelerating) {
                if listIndex != oldValue {
                    listTableViewDataUpdate()
                    listViewUpdate(emoji: currentList.emoji, title: currentList.title)
                }
            } else {
                listTableViewDataUpdate()
                listViewUpdate(emoji: currentList.emoji, title: currentList.title)
            }
        }
    }
    var listsManager = ListsManager()
    
    var currentList: List {
        get {
            if listsManager.lists.count == 0 {
                listsManager.addList(List(emoji: "📝", title: "Empty List", items: [], index: 0))
            }
            return listsManager.lists[listIndex]
        }
    }
    
    var isCreatingList: Bool = false

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
 
        self.inputItemTextView.delegate = self
        self.listTitleTextField.delegate = self
        
//         listsThumbnailCollectionViewDataUpdate()
//         listTableViewDataUpdate()
        
        ////List Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
     
        ////View
        listsThumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: listsThumbnailCollectionView.frame.size.width-ListsThumbnailCollectionViewCell.width*3-12)
        
        listsThumbnailCollectionView.showsHorizontalScrollIndicator = false
        
        listViewUpdate(emoji: currentList.emoji, title: currentList.title)
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        inputItemView.isHidden = true
        
        inputItemTextView.autocapitalizationType = .none

        ////Timer
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ListViewController.updateTimeLabel), userInfo: nil, repeats: true)
        
        
    }
    
    // MARK: - Buttons Action
    
    
    @IBAction func listTitleButtonTapped(_ sender: Any) {
        
        listTitleTextField.text = listTitleButton.titleLabel!.text
        setHidden(listTitle: true, textField: false)
        
        listTitleButton.setTitle("", for: .normal)
        
        listTitleTextField.becomeFirstResponder()
        listTitleTextField.returnKeyType = .default
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        resetToPlaceHolder()
        inputItemView.isHidden = !inputItemView.isHidden
        
        inputItemTextView.becomeFirstResponder()
    }
    
    // MARK: - Text View
    
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
    
    // MARK: - Text Field
    
    @IBAction func textFieldEdittingDidBegin(_ sender: UITextField) {
        if sender == listTitleTextField {
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
                listTitleTextField.attributedPlaceholder = NSAttributedString(string: "Enter your item", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                return false
            }
            
            currentList.title = listTitleTextField.text!
            
            listViewUpdate(title: listTitleTextField.text)
            setHidden(listTitle: false, textField: true)
            
            listsThumbnailCollectionViewDataUpdate()
            
            if isCreatingList == true {
                listsThumbnailCollectionView.scrollToItem(at: IndexPath(row: listsManager.lists.count, section: 0), at: .right, animated: true)
            }
            
            isCreatingList = false
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
                return updatedText.count < 36
        }
        
        return true
    }

    @IBAction func closeTextField(_ sender: Any) {
        inputItemView.isHidden = true
        inputItemTextView.resignFirstResponder()
    }
    
    
    // MARK: - Convenience methods
    
    // MARK: Model & Data
    func loadList() {
        
        listsManager.lists = DataManager.loadAll(from: List.self).sorted {
            $0.index < $1.index
        }
        
        if listsManager.lists.isEmpty {
            listsManager.lists = [
            List(emoji: "📆", title: "ToDo", items: [
                Item(title: "Tap here to delete"),
                Item(title: "Tap list name to change"),
                Item(title: "Tap emoji to change")
                ]
                , index: 0),
            List(emoji: "🛒", title: "Groceries", items: [
                Item(title: "2 Tomatos"),
                Item(title: "Chicken Breast")
                ]
                , index: 1),
            List(emoji: "💻", title: "Software Engineer", items: [
                Item(title: "Design Pattern")
            ], index: 2)
            ]
            
            for index in 0...listsManager.lists.count-1 {
                listsManager.lists[index].saveList()
            }
        }
        
        listTableViewDataUpdate()
        listsThumbnailCollectionViewDataUpdate()
    }
    
    func listsThumbnailCollectionViewDataUpdate() {
           listsThumbnailCollectionViewDataService.listManager = self.listsManager
           listsThumbnailCollectionViewDataService.listIndex = self.listIndex
           
           listsThumbnailCollectionViewDataService.collectionView = listsThumbnailCollectionView
           
           listsThumbnailCollectionViewDataService.listUpdateService = self
          
           listsThumbnailCollectionView.reloadData()
       }
       
       func listTableViewDataUpdate() {
           dataService.listsManager = self.listsManager
           dataService.listIndex = self.listIndex
        
            dataService.pullDownService = self
           
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
    
    func listViewUpdate(emoji: String? = nil, title: String? = nil) {
        if emoji != nil {
            emojiButton.setTitle(emoji, for: .normal) }
        if title != nil {
            listTitleButton.setTitle(title, for: .normal) }

    }
    
    func setHidden(listTitle: Bool, textField: Bool) {

        self.listTitleButton.isHidden = listTitle
        self.listTitleTextField.isHidden = textField
        
    }
    
    // MARK: Actions
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "" else {
            throw ListVCError.emptyText
        }
        
        let newItem = Item(title: textView.text!)
        self.currentList.addItemAtTop(newItem)
        listTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    // MARK: Text Field
    
    func resetToPlaceHolder() {
        inputItemTextView.text = "Enter your item"
        inputItemTextView.textColor = UIColor.lightGray
    
        inputItemTextView.selectedTextRange = inputItemTextView.textRange(from: inputItemTextView.beginningOfDocument, to: inputItemTextView.beginningOfDocument)
        
        inputItemTextView.returnKeyType = .done
        inputItemTextView.reloadInputViews()
    }
    
    
    // MARK: - Segues
    
    @IBAction func unwindToListViewController(segue: UIStoryboardSegue) {
        if segue.identifier == Segues.saveEmoji {
            let emojiPageVC = segue.source as! EmojiPageViewController
     
            guard emojiPageVC.selectedEmoji != nil else { return }
            
            self.currentList.emoji = emojiPageVC.selectedEmoji!
            emojiButton.setTitle(emojiPageVC.selectedEmoji, for: .normal)
            
            listsThumbnailCollectionView.reloadData()
        }
        
        if segue.identifier == Segues.selectedList {
            let listsTableVC = segue.source as! ListsTableViewController
            
            if let selectedIndexPath = listsTableVC.tableView.indexPathForSelectedRow {
                self.listIndex = selectedIndexPath.row
            } else if listsTableVC.hasDeleted {
                self.listIndex = 0
            }
            listsThumbnailCollectionView.scrollToItem(at: IndexPath(row: listIndex+1, section: 0), at: .right, animated: true)
          
//            listTableViewDataUpdate()
            listsThumbnailCollectionViewDataUpdate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toListsTableView {
            guard let navigationVC = segue.destination as? UINavigationController else {
                fatalError()
            }
            
            guard let listsTableVC = navigationVC.viewControllers[0] as? ListsTableViewController else {
                fatalError()
            }
            
            listsTableVC.listsManager = self.listsManager
        }
        
        if segue.identifier == Segues.selectedList {
            guard let navigationVC = segue.destination as? UINavigationController else {
                fatalError()
            }
            guard let listsTableVC = navigationVC.viewControllers[0] as? ListsTableViewController else {
                fatalError()
            }
        }
    }
    
    // MARK: - Configure List Display
    
    func updateList(from offset: Double) {
        
        let cellWidth = Double(ListsThumbnailCollectionViewCell.width)
        
            if Int(offset/cellWidth) <= listsManager.lists.count-1 && offset > 0 {
                    listIndex = Int(offset/cellWidth)
            } else if Int(offset/cellWidth) >= listsManager.lists.count {
                    listIndex = listsManager.lists.count-1
            } else if Int(offset/cellWidth) <= 0 {
                    listIndex = 0
            }
        
    }
    
    func addNewList() {
        isCreatingList = true

        let newList = List(emoji: "😐", title: "New List", items: [], index: listsManager.lists.count)
        listsManager.addList(newList)
        listIndex = listsManager.lists.count-1
        
        listTitleTextField.text = ""
        listTitleTextField.attributedPlaceholder = NSAttributedString(string: "Enter your item", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

        setHidden(listTitle: true, textField: false)

        listTitleTextField.becomeFirstResponder()
        listTitleTextField.returnKeyType = .default
    }
    
    func isTablePullDowned(_ value: Bool) {
        if value == true {
            if listTableView.contentOffset.y < -40 {
                self.addButtonTapped(addButton)
            }
        }
    }
    
}


