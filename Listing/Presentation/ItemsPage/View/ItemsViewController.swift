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
    
    static var storyboardID: String {
        return String(describing: ItemsViewController.self)
    }
    
    static func initialize(masterListID: String) -> ItemsViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ItemsViewController.storyboardID ) as! ItemsViewController
        
        vc.masterListID = masterListID
        
        return vc
    }
    
    // MARK: - OUTLETS
    
    /// - Page Data Service
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
    
    var isCreatingList: Bool = false
    var isKeyboardShowing: Bool = false
    
    var isAddButtonTapped: Bool = false
    
    var deletedItemIndex: IndexPath?
    var deletedItem: Item?
    var deleteFromDatabase: Bool = false
    
    /// - Item's Page View Model
    lazy var pageViewModel: ItemPageViewModel = DefaultItemPageViewModel(masterListID: masterListID)
    
    var masterListID: String = ""
    
    /// - Controller's SubList Index
    /// - Connect to ViewModel's SubList Index (If it changes, ViewModel's SubList Index followingly changes
    var subListCurrentIndex: Int = 0 {
        didSet {
            pageViewModel.subListCurrentIndex = subListCurrentIndex
            
            /// Stop listTableView load too much when list thumbnail is scrolling
            if (listsThumbnailCollectionView.isDragging || listsThumbnailCollectionView.isDecelerating) {
                if subListCurrentIndex != oldValue {
                    
                    let subList = pageViewModel.subLists.value[subListCurrentIndex]
                    listTitleViewUpdate(emoji: subList.emoji, title: subList.title)
                }
            }
            else {
                let subList = pageViewModel.subLists.value[subListCurrentIndex]
                listTitleViewUpdate(emoji: subList.emoji, title: subList.title)
            }
        }
    }
    
    var currentSubList: DomainSubList {
        if pageViewModel.subLists.value.count == 0 {
            pageViewModel.addSubList(title: "Empty List", emoji: "📝")
        }
        return pageViewModel.subLists.value[subListCurrentIndex]
    }
    


    //MARK: - VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSPersistentContainer.defaultDirectoryURL())
        
        bind(to: pageViewModel)
        pageViewModel.initiateLoadPage()
        
        
        itemsTableViewDataService.itemViewModel = pageViewModel
        listsThumbnailCollectionViewDataService.subListViewModel = pageViewModel
        
        //View
        setUpView()
        
        inputItemTextView.autocapitalizationType = .none
        
        //  Data
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
    
    private func bind(to viewModel: ItemPageViewModel) {
        viewModel.items.observe(on: self) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.itemsTableView.reloadData()
            }
        }
        
        viewModel.subLists.observe(on: self) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.listsThumbnailCollectionView.reloadData()
            }
        }
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
          
           listsThumbnailCollectionView.reloadData()
       }
       
       func listTableViewDataUpdate() {
//            itemsTableViewDataService.listIndex = self.listIndex
    
            DispatchQueue.main.async {
                self.itemsTableView.reloadData()
            }
           
       }
    
    // MARK: Model Update
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "" else {
            throw ListVCError.emptyText
        }
        
//        currentSubList.addItem(title: textView.text!, from: .top)
        pageViewModel.addItem(title: textView.text!)
        itemsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        
        
    }
    
    // MARK: View Update

    func listTitleViewUpdate(emoji: String? = nil, title: String? = nil) {
        if emoji != nil {
            emojiButton.setTitle(emoji, for: .normal) }
        if title != nil {
            listTitleButton.setTitle(title, for: .normal) }
        
        print("SubList set: title \(pageViewModel.subLists.value[subListCurrentIndex])")

    }
    
    func setHidden(listTitleTextField: Bool) {
        self.listTitleButton.isHidden = !listTitleTextField
            self.listTitleTextField.isHidden = listTitleTextField
    }


}



