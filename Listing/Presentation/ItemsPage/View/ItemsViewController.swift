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
    
    class State {
         var isCreatingList: Bool = false
        
         var isKeyboardShowing: Bool = false
        
         var isEditingItem: (value: Bool, index: Int) = (false, -1)
    }
    var controllerState = State()
    
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
                    setSubListView(emoji: subList.emoji, title: subList.title)
                }
            }
            else {
                let subList = pageViewModel.subLists.value[subListCurrentIndex]
                setSubListView(emoji: subList.emoji, title: subList.title)
            }
        }
    }
    
    var currentSubList: DomainSubList {
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
    
    // MARK: - View Model
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
    
    // MARK: - Keyboard Methods
    @objc func keyboardWillShow(_ notification: Notification) {
        if controllerState.isEditingItem.value || addButton.isTouchInside,
           let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
                inputItemToolbar.frame.origin.y = UIScreen.main.bounds.height - (keyboardHeight + inputItemToolbar.frame.height)
            
            controllerState.isKeyboardShowing = true
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        inputItemToolbar.frame.origin.y = UIScreen.main.bounds.height
        controllerState.isKeyboardShowing = false
    }
    
    // MARK: Model Update
    
    /// Add new item taken from textView to database
    func addNewItem(from textView: UITextView) throws {
        guard textView.text != "Enter your item" && textView.textColor != UIColor.lightGray else {
            throw ListVCError.emptyText
        }
        
//        currentSubList.addItem(title: textView.text!, from: .top)
        pageViewModel.addItem(title: textView.text!)
        itemsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        
        
    }
    
    /// Update/Edit item taken from Text View
    /// - Parameter index: Position of item that needs update
    /// - Throws: Text View Error
    func updateItem(from textView: UITextView, at index: Int) throws {
        guard textView.text != "Enter your item" && textView.textColor != UIColor.lightGray else {
            throw ListVCError.emptyText
        }
        
        pageViewModel.deleteItem(at: index)
        pageViewModel.insertItem(textView.text!, at: index)
        
        itemsTableView.reloadData()
    }
    
    
    // MARK: View Update

    func setSubListView(emoji: String? = nil, title: String? = nil) {
        if emoji != nil {
            emojiButton.setTitle(emoji, for: .normal) }
        if title != nil {
            listTitleButton.setTitle(title, for: .normal) }
        
        print("SubList set: title \(pageViewModel.subLists.value[subListCurrentIndex])")

    }
    
    /// - **True:** Turn sublist title into a textfield for editing
    /// - **False:** Turn sublist title back into button
    func editSubListTitle(_ value: Bool) {
        self.listTitleButton.isHidden = value
        self.listTitleTextField.isHidden = !value
    }


}



