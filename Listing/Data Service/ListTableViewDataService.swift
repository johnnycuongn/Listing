//
//  ListTableViewDataService.swift
//  Listing
//
//  Created by Johnny on 11/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ListTableViewDataService: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var listManager: ListManager?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listManager = listManager else { fatalError() }
        
        return listManager.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        guard let listManager = listManager else { fatalError() }
        
        cell.config(item: listManager.itemAtIndex(indexPath.row))
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    

}
