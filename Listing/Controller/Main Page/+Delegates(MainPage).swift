//
//  MainPage+Delegates.swift
//  Listing
//
//  Created by Johnny on 28/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

extension MainPageViewController: MainListCellExpandDelegate {
    func expandCell(_ cell: MainListTableViewCell) {
    }
}

extension MainPageViewController: MainListCellPerformSegueDelegate {
    func performSegue(with subListIndex: Int) {
    }
}

extension MainPageViewController: MainListCellAlertPresentDelegate {
    func present(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    
}
