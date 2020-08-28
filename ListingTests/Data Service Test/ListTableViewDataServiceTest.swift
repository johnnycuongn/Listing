//
//  ListTableViewDataServiceTest.swift
//  ListingTests
//
//  Created by Johnny on 18/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import XCTest
@testable import Listing

class ListTableViewDataServiceTest: XCTestCase {
    
    var sut: ItemsTableViewDataService!
    var listTableView: UITableView!
    var listViewController: ItemsViewController!
    
    let swift = Item(title: "Swift", index: 0, itemIdentifier: UUID())
    let python = Item(title: "Python", index: 0, itemIdentifier: UUID())
    let java = Item(title: "Java", index: 0, itemIdentifier: UUID())
    
    var listTableViewMock: TableViewMock!

    override func setUpWithError() throws {
        sut = ItemsTableViewDataService()
        sut.listManager = ListOfItemManager()
        
        listViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ListViewControllerID") as! ItemsViewController
        _ = listViewController.view
        
        listTableView = listViewController.itemsTableView
        
        listTableView.dataSource = sut
        listTableView.delegate = sut
        
        listTableViewMock = TableViewMock.initMock(datasource: sut)
        
        sut.listManager?.deleteItem(at: 0)
        DataManager.clearAll()
    }

    override func tearDownWithError() throws {
        
    }

    // MARK: - Section
    func test_ReturnOneSection() {
        XCTAssertEqual(listTableView.numberOfSections, 1)
    }
    
    // MARK: - Number Of Rows - Item added
    func testTableViewRows_ItemAdded_ReturnListCount() {
        sut.listManager?.addItemAtTop(swift)
        sut.listManager?.addItemAtTop(python)
        listTableView.reloadData()
        
        XCTAssertEqual(listTableView.numberOfRows(inSection: 0), sut.listManager?.listCount)
    }
    
    func testTableViewRows_ItemDeleted_ReturnListCount() {
        sut.listManager?.addItemAtTop(swift)
        sut.listManager?.addItemAtTop(python)
        sut.listManager?.addItemAtTop(java)
        
        sut.listManager?.deleteItem(at: 0)
        listTableView.reloadData()
        
        XCTAssertEqual(listTableView.numberOfRows(inSection: 0), sut.listManager?.listCount)
    }
    
    // MARK: - Data Source
    func testCells_IsDequeuedAsItemCell() {
        sut.listManager?.addItemAtTop(swift)
        listTableView.reloadData()
        
        let cellQueried = listTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cellQueried is ItemCell)
    }
    
    func testDataSource_ShouldDequeCell() {
        sut.listManager?.addItemAtTop(swift)
        listTableViewMock.reloadData()
        
        _ = listTableViewMock.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(listTableViewMock.isItemDequeued)
    }
    
    func testDataSource_ShouldSetCellData() {
        sut.listManager?.addItemAtTop(swift)
        listTableViewMock.reloadData()
        
        let cell = listTableViewMock.cellForRow(at: IndexPath(row: 0, section: 0)) as? ItemCellMock
        
        XCTAssertEqual(cell?.itemData?.title, swift.title)
    }
    
    // MARK: - Delegate
    
    
    
    // MARK: - Mock
    class ItemCellMock: ItemCell {
        var itemData: Item?
        override func config(item: Item)  {
            itemData = item
        }
    }
    
    class TableViewMock: UITableView {
        var isItemDequeued = false
        
        class func initMock(datasource: ItemsTableViewDataService) -> TableViewMock {
            
            let mock = TableViewMock(frame: CGRect.init(x: 500, y: 500, width: 500, height: 500), style: .plain)
            
            mock.dataSource = datasource
            mock.register(ItemCellMock.self, forCellReuseIdentifier: "itemCell")
            
            return mock
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            isItemDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
}
    


