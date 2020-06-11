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
    
    var listManager = ListManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true

        listTableView.dataSource = dataService
        listTableView.delegate = dataService
        

        dataService.listManager = listManager

        dataService.listManager?.addItem(Item(title: "Learn Swift"))
        dataService.listManager?.addItem(Item(title: "Do Somethign"))
        
        listTableView.reloadData()
    }


}

