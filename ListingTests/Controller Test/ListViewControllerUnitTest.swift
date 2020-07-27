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
        XCTAssertNotNil(sut.listTableView)
    }
    
    // MARK: - DataSource and Delegate
    func testDataSource_ViewDidLoad_SetTableViewDatasource() {
        XCTAssertNotNil(sut.listTableView.dataSource)
        XCTAssert(sut.listTableView.dataSource is ItemsTableViewDataService)
    }
    
    func testDelegate_ViewDidLoad_SetTableViewDelegate() {
        XCTAssertNotNil(sut.listTableView.delegate)
        XCTAssert(sut.listTableView.delegate is ItemsTableViewDataService)
    }
    
    func testDataService_ViewDidLoad_SingleDataServiceObject() {
        XCTAssertEqual(sut.listTableView.dataSource as! ItemsTableViewDataService, sut.listTableView.delegate as! ItemsTableViewDataService)
    }
    
    

}
