//
//  ViewController.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
    
    /// - Systems
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ListTableViewDataService!
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
        dataService.listManager = listManager
        
        ////Table View
        listTableView.isEditing = true
        listTableView.allowsSelectionDuringEditing = true
        
        ////View
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        inputItemView.isHidden = true
        
        ////Timer
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ListViewController.updateTimeLabel), userInfo: nil, repeats: true)
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
        guard let titleEntered = inputItemTextField.text else { fatalError() }
        listManager.addItemAtFirst(Item(title: titleEntered))
        listTableView.reloadData()
        
        inputItemTextField.text = ""
    }
    
    @IBAction func closeTextField(_ sender: Any) {
        inputItemView.isHidden = true
        inputItemTextField.resignFirstResponder()
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

