//
//  ListsViewController.swift
//  Listing
//
//  Created by Johnny on 25/7/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

//struct MainPageStoryBoard {
//    static var tableViewTopAnchor: CGFloat = 60
//    static var largestTableViewHeight: CGFloat {
//        return UIScreen.main.bounds.size.height - tableViewTopAnchor*2
//    }
//}

class MainPageViewController: UIViewController {
    

    var selectedIndexPath: IndexPath?

    @IBOutlet weak var mainListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainListCollectionView.delegate = self
        mainListCollectionView.dataSource = self
        
        mainListCollectionView.dropDelegate = self
        mainListCollectionView.dragDelegate = self
        mainListCollectionView.dragInteractionEnabled = true
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainListCollectionView.frame.width,
                      height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainListManager.mainLists.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCollectionViewCell.identifier, for: indexPath) as? MainListCollectionViewCell else {
            print("MainPageViewController: Can't dequeue collection view cell at \(indexPath)")
            return UICollectionViewCell()
        }
        
        if indexPath.row == MainListManager.mainLists.count {
            cell.config(with: "+")
        
        }
        else {
            let mainList = MainListManager.mainLists[indexPath.row]
            
            cell.config(with: mainList.title ?? "No Value")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < MainListManager.mainLists.count {
            print("MainList Selected: \(MainListManager.mainLists[indexPath.row].title)")
        } else if indexPath.row == MainListManager.mainLists.count {
            addNewMainList()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        MainListManager.move(from: sourceIndexPath, to: destinationIndexPath)
    }

}

// MARK: DROP
extension MainPageViewController: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UICollectionViewDropProposal(operation: .forbidden)
    }


    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }

        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }

    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first
            , let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                guard destinationIndexPath.row < MainListManager.mainLists.count else {
                    return
                }
                MainListManager.move(from: sourceIndexPath, to: destinationIndexPath)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

}

// MARK: DRAG
extension MainPageViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard indexPath.row < MainListManager.mainLists.count else {
            return []
        }
        
        let list = MainListManager.mainLists[indexPath.row].title
        let itemProvider = NSItemProvider(object: list! as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = list
        
        return [dragItem]
    }
}


