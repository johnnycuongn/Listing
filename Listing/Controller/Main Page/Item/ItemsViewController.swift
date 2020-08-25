//
//  ViewController.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit
import Foundation
import CoreData

enum ListVCError: Error {
    case emptyText
}

class ItemsViewController: UIViewController {

    /// - Systems
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ItemsTableViewDataService!
    
    
    @IBOutlet weak var listIndicator: UILabel!
    @IBOutlet weak var listsThumbnailCollectionView: UICollectionView!
    var listsThumbnailCollectionViewLayout: UICollectionViewFlowLayout {
        return listsThumbnailCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    var listsThumbnailWidth: CGFloat {
        return listsThumbnailCollectionView.frame.size.height
    }
    
    @IBOutlet var listsThumbnailCollectionViewDataService: ListsThumbnailCollectionViewDataService!
    
    /// - List's Emoji and Title
    @IBOutlet weak var emojiButton: UIButton!
    
    @IBOutlet weak var listTitleButton: UIButton!
    @IBOutlet weak var listTitleTextField: UITextField!
    
    /// - Input Item Outlets
    @IBOutlet weak var inputItemTextView: UITextView!
    @IBOutlet weak var inputItemView: UIStackView!
    @IBOutlet var inputItemToolbar: UIView!
    @IBOutlet weak var toolbarAddButton: UIButton!
    
    
    /// - View's Buttons Outlets
    @IBOutlet weak var addButton: UIButton!
    
    /// - Undo View
    @IBOutlet weak var undoButton: UIButton!
    
    /// - Model Variables
    var listIndex = 0 {
        didSet {
            /// Stop listTableView load too much when list thumbnail is scrolling
            if (listsThumbnailCollectionView.isDragging || listsThumbnailCollectionView.isDecelerating) {
                if listIndex != oldValue {
                    listTitleViewUpdate(emoji: currentSubList.emoji, title: currentSubList.title)
                    listTableViewDataUpdate()
                }
            } else {
                listTitleViewUpdate(emoji: currentSubList.emoji, title: currentSubList.title)
                listTableViewDataUpdate()
            }
        }
    }
    var currentMainList: MainList {
        return MainListManager.mainLists[0]
    }
    
    var currentSubList: SubList {
        get {
            if currentMainList.subListsArray.count == 0 {
//                currentMainList.addSubList(List(emoji: "📝", title: "Empty List", items: [], index: 0))
                currentMainList.addSubList(title: "Empty List", emoji: "📝")
            }
            return currentMainList.subListsArray[listIndex]
        }
    }
    
    var isCreatingList: Bool = false
    var isKeyboardShowing: Bool = false
    
    var deletedItemIndex: IndexPath?
    var deletedItem: Item?

    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSPersistentContainer.defaultDirectoryURL())
        if MainListManager.mainLists.isEmpty {
            MainListManager.append(title: "This is main list", emoji: "😀")
        }
        ////    Data
        loadList()

        // Delegate and datasource
        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        
        listTableView.dragInteractionEnabled = true // Enable intra-app drags for iPhone.
        listTableView.dragDelegate = dataService
        listTableView.dropDelegate = dataService
        
        listsThumbnailCollectionView.dataSource = listsThumbnailCollectionViewDataService
        listsThumbnailCollectionView.delegate = listsThumbnailCollectionViewDataService
 
        self.inputItemTextView.delegate = self
        
        self.listTitleTextField.delegate = self
        
        //View
        setUpView()
        
        listTitleViewUpdate(emoji: currentSubList.emoji, title: currentSubList.title)
    
        inputItemTextView.autocapitalizationType = .none
    }
        
        
    
    // MARK: - Buttons Action
    
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
        inputItemView.isHidden = !inputItemView.isHidden
        
        inputItemTextView.becomeFirstResponder()
        isKeyboardShowing = true
    }
    
    // MARK: Input item Toolbar
    @IBAction func closeItemInputView(_ sender: Any) {
        isKeyboardShowing = false
        inputItemView.isHidden = true
        inputItemTextView.resignFirstResponder()
    }
    
    @IBAction func toolbarAddButtonTapped(_ sender: UIButton) {
        do {
            try addNewItem(from: inputItemTextView)
                resetInputTextView()
        } catch {
        }
    }
    
    
    @IBAction func undoButtonTapped(_ sender: UIButton) {
        
        guard let deletedItem = deletedItem,
            let deletedItemIndex = deletedItemIndex else {
            return
        }
        
//         self.currentSubList.itemsArray.insert(deletedItem, at: deletedItemIndex.row)
        self.currentSubList.insertItem(deletedItem.title!, at: deletedItemIndex.row)
        self.listTableView.insertRows(at: [deletedItemIndex], with: .fade)
        
        self.stopTimer()
        undoViewPresented(false)
    }
    
    // MARK: - Helper Methods
    
    // MARK: Reload Instance
    func listsThumbnailCollectionViewDataUpdate() {
//           listsThumbnailCollectionViewDataService.currentMainList = self.listsManager
           listsThumbnailCollectionViewDataService.listIndex = self.listIndex
           
           listsThumbnailCollectionViewDataService.collectionView = listsThumbnailCollectionView
           
           listsThumbnailCollectionViewDataService.listUpdateService = self
          
           listsThumbnailCollectionView.reloadData()
       }
       
       func listTableViewDataUpdate() {
//           dataService.currentMainList = self.listsManager
           dataService.listIndex = self.listIndex
        
            dataService.pullDownService = self
        dataService.cellUndoable = self
           
           listTableView.reloadData()
       }
    
    // MARK: Model Update
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "" else {
            throw ListVCError.emptyText
        }
        
//        let newItem = Item(title: textView.text!)
//        self.currentList.addItem(newItem, from: .top)
        currentSubList.addItem(title: textView.text!, from: .top)
        listTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    // MARK: View

    func listTitleViewUpdate(emoji: String? = nil, title: String? = nil) {
        if emoji != nil {
            emojiButton.setTitle(emoji, for: .normal) }
        if title != nil {
            listTitleButton.setTitle(title, for: .normal) }

    }
    
    func setHidden(listTitleTextField: Bool) {
        self.listTitleButton.isHidden = !listTitleTextField
            self.listTitleTextField.isHidden = listTitleTextField
    }
    
    @objc func undoViewPresented(_ isPresented: Bool = false) {
        if isPresented == false {
            listIndicator.isHidden = false
            self.listsThumbnailCollectionView.isHidden = false
            undoButton.isHidden = true
        } else {
            listIndicator.isHidden = true
            listsThumbnailCollectionView.isHidden = true
            undoButton.isHidden = false
        }
    }

    // MARK: - Convinience Methods
    var timer: Timer?
    var undoTime: Double = 3
    
    func startTimer() {
        print("Timer Start")
        timer = Timer.scheduledTimer(timeInterval: undoTime, target: self, selector: #selector(self.undoViewPresented), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}



