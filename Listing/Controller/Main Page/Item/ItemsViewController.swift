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

class ItemsViewController: UIViewController, UITextViewDelegate,  UITextFieldDelegate {

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
                    listTitleViewUpdate(emoji: currentList.emoji, title: currentList.title)
                    listTableViewDataUpdate()
                }
            } else {
                print("Load - No Scrolling: \(listIndex)")
                listTitleViewUpdate(emoji: currentList.emoji, title: currentList.title)
                listTableViewDataUpdate()
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
    var isKeyboardShowing: Bool = false
    
    var deletedItemIndex: IndexPath?
    var deletedItem: Item?

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

        ////List Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
     
        ////View
        setUpView()
        
        listTitleViewUpdate(emoji: currentList.emoji, title: currentList.title)
    
        inputItemTextView.autocapitalizationType = .none
    }
        
        
    
    // MARK: - Buttons Action
    
    
    @IBAction func listTitleButtonTapped(_ sender: Any) {
        listTitleTextField.text = listTitleButton.titleLabel!.text
        setHidden(listTitleTextField: false)
        
        listTitleButton.setTitle("", for: .normal)
        
        listTitleTextField.becomeFirstResponder()
        listTitleTextField.returnKeyType = .default
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        resetToPlaceHolder()
        inputItemView.isHidden = !inputItemView.isHidden
        
        inputItemTextView.becomeFirstResponder()
        isKeyboardShowing = true
    }

    @IBAction func closeItemInputView(_ sender: Any) {
        isKeyboardShowing = false
        inputItemView.isHidden = true
        inputItemTextView.resignFirstResponder()
    }
    
    @IBAction func undoButtonTapped(_ sender: UIButton) {
        
        guard let deletedItem = deletedItem,
            let deletedItemIndex = deletedItemIndex else {
            return
        }
        
         self.currentList.items.insert(deletedItem, at: deletedItemIndex.row)
        self.listTableView.insertRows(at: [deletedItemIndex], with: .fade)
        
        self.stopTimer()
        undoViewPresented(false)
    }
    
    // MARK: - Set Up
    func loadList() {
        
        listsManager.lists = DataManager.loadAll(from: List.self).sorted {
            $0.index < $1.index
        }
        
        if listsManager.lists.isEmpty {
            listsManager.lists = [
            List(emoji: "📆", title: "ToDo", items: [
                Item(title: "Tap here to delete"),
                Item(title: "Tap list title to change"),
                ]
                , index: 0),
            List(emoji: "🛒", title: "Groceries", items: [
                Item(title: "2 Tomatos"),
                Item(title: "Chicken Breast")
                ]
                , index: 1)
            ]
            
            listsManager.updateIndexForLists()
        }
        
        listTableViewDataUpdate()
        listsThumbnailCollectionViewDataUpdate()
    }
    
    func setUpView() {
        /// Undo Button
        undoViewPresented(false)
        undoButton.layer.cornerRadius = 10
        undoButton.layer.borderWidth = 0.7
        undoButton.layer.borderColor = UIColor.init(named: "Destructive")?.cgColor
        undoButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        view.bringSubviewToFront(undoButton)
        /// List Thumbnail Collection View
        listsThumbnailCollectionViewLayout.itemSize = CGSize(width: listsThumbnailWidth, height: listsThumbnailWidth)
       listsThumbnailCollectionViewLayout.minimumLineSpacing = 5
       listsThumbnailCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: listsThumbnailCollectionView.frame.size.width-(listsThumbnailWidth*3))
        listsThumbnailCollectionView.showsHorizontalScrollIndicator = false
        
        /// Add Button
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        
        /// Item Input Itew
        inputItemView.isHidden = true
        
    }
    
    // MARK: - Helper Methods
    
    // MARK: Reload Instance
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
        dataService.cellUndoable = self
           
           listTableView.reloadData()
       }
    
    // MARK: Model Update
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "" else {
            throw ListVCError.emptyText
        }
        
        let newItem = Item(title: textView.text!)
        self.currentList.addItem(newItem, from: .top)
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



