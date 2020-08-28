//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var mainListsTableView: UITableView!

    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainListsTableView.delegate = self
        mainListsTableView.dataSource = self
        
    }

}
extension MainPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPath == nil {
            return 60
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainListManager.mainLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListTableViewCell.identifier, for: indexPath) as? MainListTableViewCell else {
            fatalError()
        }
        
        let mainList = MainListManager.mainLists[0]
        
        cell.config(with: mainList.title!)
        cell.indexPath = indexPath
        
        cell.expandDelegate = self
        cell.segueDelegate = self
        cell.alertPresentDelegate = self
        
        return cell
    }
    
    
}

extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexPath == nil, let selected = mainListsTableView.indexPathForSelectedRow  {
            selectedIndexPath = selected
        }
        else {
            selectedIndexPath = nil
        }
        
        mainListsTableView.reloadData()
    }
}

