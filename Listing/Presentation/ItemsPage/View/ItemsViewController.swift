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
    
    static func initialize(with indexPath: IndexPath) -> ItemsViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ItemsViewController") as! ItemsViewController
        
        vc.mainListIndexPath = indexPath
        
        return vc
    }

    /// - Systems
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet var itemsTableViewDataService: ItemsTableViewDataService!
    
    
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
    @IBOutlet var inputItemToolbar: UIView!
    @IBOutlet weak var toolbarAddButton: UIButton!
    
    
    /// - View's Buttons Outlets
    @IBOutlet weak var addButton: UIButton!
    
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
    
    var mainListIndexPath: IndexPath!
    
    var currentMainList: MainList {
        return MainListManager.mainLists[self.mainListIndexPath.row]
    }
    
    var currentSubList: SubList {
        get {
            if currentMainList.subListsArray.count == 0 {
                currentMainList.addSubList(title: "Empty List", emoji: "📝")
            }
            return currentMainList.subListsArray[listIndex]
        }
    }
    
    var isCreatingList: Bool = false
    var isKeyboardShowing: Bool = false
    
    var isAddButtonTapped: Bool = false
    
    var deletedItemIndex: IndexPath?
    var deletedItem: Item?
    var deleteFromDatabase: Bool = false

    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSPersistentContainer.defaultDirectoryURL())
        if MainListManager.mainLists.isEmpty {
            MainListManager.append(title: "This is main list", emoji: "😀")
        }
        //View
        setUpView()
            
        listTitleViewUpdate(emoji: currentSubList.emoji, title: currentSubList.title)
        
        inputItemTextView.autocapitalizationType = .none
        
        //  Data
        loadListIndex()
        
        setUpItemTableViewData()
        setUpListsThumbnailCollectionViewData()
        
        itemsTableView.reloadData()
        listsThumbnailCollectionView.reloadData()
        
        itemsTableView.dragInteractionEnabled = true /// Enable intra-app drags for iPhone.
 
        // Delegate
        self.inputItemTextView.delegate = self
        self.listTitleTextField.delegate = self
        
        self.view.addSubview(inputItemToolbar)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
    
        if isAddButtonTapped, let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            inputItemToolbar.frame.origin.y -= keyboardHeight + inputItemToolbar.frame.height
            
            isAddButtonTapped = false
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        inputItemToolbar.frame.origin.y = UIScreen.main.bounds.height
    }
        
    // MARK: - Helper Methods
    
    // MARK: Reload Index
    func listsThumbnailCollectionViewDataUpdate() {
           listsThumbnailCollectionViewDataService.listIndex = self.listIndex
          
           listsThumbnailCollectionView.reloadData()
       }
       
       func listTableViewDataUpdate() {
            itemsTableViewDataService.listIndex = self.listIndex
    
            DispatchQueue.main.async {
                self.itemsTableView.reloadData()
            }
           
       }
    
    // MARK: Model Update
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "" else {
            throw ListVCError.emptyText
        }
        
        currentSubList.addItem(title: textView.text!, from: .top)
        itemsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    // MARK: View Update

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


}



