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
        
        listTableView.dragInteractionEnabled = true /// Enable intra-app drags for iPhone.
 
        // Delegate
        self.inputItemTextView.delegate = self
        self.listTitleTextField.delegate = self
        
    
    }
        
    // MARK: - Helper Methods
    
    // MARK: Reload Index
    func listsThumbnailCollectionViewDataUpdate() {
           listsThumbnailCollectionViewDataService.listIndex = self.listIndex
          
           listsThumbnailCollectionView.reloadData()
       }
       
       func listTableViewDataUpdate() {
            dataService.listIndex = self.listIndex
    
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
           
       }
    
    // MARK: Model Update
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "" else {
            throw ListVCError.emptyText
        }
        
        currentSubList.addItem(title: textView.text!, from: .top)
        listTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
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



