//
//  ViewController.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var dataService: ListTableViewDataService!
    @IBOutlet weak var addButton: UIButton!
    
    var listManager = ListManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        
        dataService.listManager = listManager

        dataService.listManager?.addItem(Item(title: "Learn Swift"))
        dataService.listManager?.addItem(Item(title: "Do Somethign"))
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 1.5
        
        listTableView.reloadData()
        listTableView.isEditing = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            guard let edittingVC = segue.destination as? EdittingViewController else { return }
            let indexPath = listTableView.indexPathForSelectedRow!

            edittingVC.itemToEdit = listManager.itemAtIndex(indexPath.row)
            edittingVC.itemToEditIndexPath = indexPath
        }

    }
    
    @IBAction func unwindToListViewController(segue: UIStoryboardSegue) {

        guard segue.identifier == "saveItemSegue" else { return }
        
        let edittingVC = segue.source as! EdittingViewController
        guard let edittingItem = edittingVC.itemToEdit else { return }
        
        if edittingVC.itemToEditIndexPath != nil {
                print("Editing Item: \(edittingItem.title)")
                let edittingIndexPath = edittingVC.itemToEditIndexPath!

                listManager.changeItem(edittingItem, at: edittingIndexPath.row)

                listTableView.reloadData()
            }
        else {
                listManager.addItem(edittingItem)
                
                listTableView.reloadData()
            }
    }

}

