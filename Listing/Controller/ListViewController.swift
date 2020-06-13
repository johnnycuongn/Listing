//
//  ViewController.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController, UITextFieldDelegate {
    
    /// - Systems
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
    var listManager = ListManager()

    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //// Delegate and datasource
        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        dataService.listManager = self.listManager
        
        self.inputItemTextField.delegate = self
//        textFieldHandler.listManager = self.listManager
        
        ////Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
        loadData()
        
        ////View
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        inputItemView.isHidden = true
        
        ////Timer
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ListViewController.updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    func loadData() {
//        listManager.itemsInList = DataManager.loadAll(from: Item.self).sorted { (item1, item2) -> Bool in
//            item1.index < item2.index
//            }
//        
        listTableView.reloadData()
    }
    
    // MARK: - Actions
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        inputItemTextField.text = ""
        addItemButton.isHidden = true
        inputItemView.isHidden = !inputItemView.isHidden
        
        inputItemTextField.becomeFirstResponder()
    }
    
    // MARK: - Input Item Actions
    
    @IBAction func textFieldEdittingChanged(_ sender: Any) {
        addItemButton.isHidden = !inputItemTextField.hasText
    }
    
    @IBAction func addItemButton(_ sender: UIButton) {
        addNewItem(from: inputItemTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addNewItem(from: inputItemTextField)
        return true
    }
    
    @IBAction func closeTextField(_ sender: Any) {
        inputItemView.isHidden = true
        inputItemTextField.resignFirstResponder()
        
        print(listManager.newList)
    }
    
    
    // MARK: - Convenience methods
    
    @objc func updateTimeLabel() {
        let today = Date() ; let tomorrow = Date(timeIntervalSinceNow: 86400)
        let startOfTomorrow = Calendar.current.startOfDay(for: tomorrow)
        let timeUntilTomorrow = today.distance(to: startOfTomorrow)

            let timeLeft = timeUntilTomorrow.convertToHourMinutes()
            self.hourLeftLabel.text = "\(timeLeft.hour)"
            self.minuteLeftLabel.text = "\(timeLeft.minutes)"
    }
    
    func addNewItem(from textField: UITextField) {
        guard let titleEntered = textField.text else { fatalError() }
        
        let newItem = Item(title: titleEntered, index: 0, itemIdentifier: UUID())
//        newItem.save()
        listManager.addItemAtFirst(newItem)
        listTableView.reloadData()
        
        inputItemTextField.text = ""
        
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
    
//    @IBAction func unwindToListViewController(segue: UIStoryboardSegue) {
//
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
//    }

}

