//
//  ListViewControllerUnitTest.swift
//  ListingTests
//
//  Created by Johnny on 17/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import XCTest
@testable import Listing

class ListViewControllerUnitTest: XCTestCase {
    
    var sut: ItemsViewController!

    override func setUpWithError() throws {
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ListViewControllerID") as? ItemsViewController
        _ = sut.view
    }

    override func tearDownWithError() throws {
        
    }

    // MARK: - List Table View
    
    func testListVC_TableView_ReturnNotNil() {
        XCTAssertNotNil(sut.itemsTableView)
    }
    
    // MARK: - DataSource and Delegate
    func testDataSource_ViewDidLoad_SetTableViewDatasource() {
        XCTAssertNotNil(sut.itemsTableView.dataSource)
        XCTAssert(sut.itemsTableView.dataSource is ItemsTableViewDataService)
    }
    
    func testDelegate_ViewDidLoad_SetTableViewDelegate() {
        XCTAssertNotNil(sut.itemsTableView.delegate)
        XCTAssert(sut.itemsTableView.delegate is ItemsTableViewDataService)
    }
    
    func testDataService_ViewDidLoad_SingleDataServiceObject() {
        XCTAssertEqual(sut.itemsTableView.dataSource as! ItemsTableViewDataService, sut.itemsTableView.delegate as! ItemsTableViewDataService)
    }
    
    

}
