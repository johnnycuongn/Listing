//
//  ItemStructTest.swift
//  ListingTests
//
//  Created by Johnny on 17/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import XCTest
@testable import Listing

class ItemStructTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Initialization
    
    func testInit_ItemWithProperties() {
        let newItem = Item(title: "Sample 1", index: 0, itemIdentifier: UUID())
        
        XCTAssertNotNil(newItem)
        
        XCTAssertEqual(newItem.title, "Sample 1")
        XCTAssertEqual(newItem.index, 0)
    }
    
    
    // MARK: - Method
    
    func testMethod_ItemCanChangeIndex() {
        var newItem = Item(title: "Sample 1", index: 0, itemIdentifier: UUID())
        newItem.changeIndex(by: 1)
        
        XCTAssertEqual(newItem.index, 1)
    }
    
    
    
    

}
