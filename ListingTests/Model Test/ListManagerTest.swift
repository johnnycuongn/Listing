//
//  ListManagerTest.swift
//  ListingTests
//
//  Created by Johnny on 17/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import XCTest
@testable import Listing

class ListManagerTest: XCTestCase {
    
    var sut: ListManager!
    
    let swift = Item(title: "Swift", index: 0, itemIdentifier: UUID())
    let python = Item(title: "Python", index: 0, itemIdentifier: UUID())
    let java = Item(title: "Java", index: 0, itemIdentifier: UUID())

    override func setUpWithError() throws {
        sut = ListManager()
        sut.deleteItem(at: 0)
    }

    override func tearDownWithError() throws {
    }
    
    // MARK: - Initial Values
    func testInit_listCount_ReturnsZero() {
        XCTAssertEqual(sut.listCount, 0)
    }
    
    // MARK: - Add & Query
    func testAdd_listCount_ReturnsOne() {
        sut.addItemAtTop(swift)
        XCTAssertEqual(sut.listCount, 1)
    }
    
    func testAdd_Item_ReturnItemAtIndexZero() {
        sut.addItemAtTop(swift)
        let itemAddedToTop = sut.itemAtIndex(0)
        
        XCTAssertEqual(itemAddedToTop.title, swift.title)
        XCTAssertEqual(itemAddedToTop.index, 0)
    }
    
    func testAdd_Item_AddedToTop() {
        sut.addItemAtTop(swift)
        sut.addItemAtTop(python)
        
        let itemAddedToTop = sut.itemAtIndex(0)
        
        XCTAssertEqual(itemAddedToTop.title, python.title )
        XCTAssertEqual(itemAddedToTop.index, 0)
    }
    
    func testAdd_Item_ChangeIndexForOtherItems() {
        sut.addItemAtTop(swift)
        sut.addItemAtTop(python)
        
        let currentSwift = sut.itemAtIndex(1)
        
        XCTAssertEqual(currentSwift.title, swift.title)
        XCTAssertEqual(currentSwift.index, 1)
    }
    
    // MARK: - Replace
    func testReplace_ChangeItemAtIndex() {
        sut.addItemAtTop(swift)
        sut.replaceItem(with: python, at: 0)
        
        XCTAssertEqual(sut.itemAtIndex(0).title, python.title)
    }
    
    // MARK: - Delete
    func testDelete_RemoveItemFromList() {
        sut.addItemAtTop(swift)
        sut.addItemAtTop(python)
        // 0. python
        // 1. swift
        XCTAssertEqual(sut.listCount, 2)
        
        sut.deleteItem(at: 0)
        // 0. swift
        XCTAssertEqual(sut.listCount, 1)
        XCTAssertEqual(sut.itemAtIndex(0).title, swift.title)
        XCTAssertEqual(sut.itemAtIndex(0).index, 0)
    }

    // MARK: - Move
    func testMove_ItemMovedFromTopToEnd() {
        sut.addItemAtTop(swift)
        sut.addItemAtTop(python)
        sut.addItemAtTop(java)
        // 0. java
        // 1. python
        // 2. swift
        XCTAssertEqual(sut.itemAtIndex(0).title, java.title)
        XCTAssertEqual(sut.itemAtIndex(0).index, 0)
        sut.moveItem(from: 0, to: 2)
        // 0. python
        // 1. swift
        // 2. java
        XCTAssertEqual(sut.itemAtIndex(0).title, python.title)
        XCTAssertEqual(sut.itemAtIndex(0).index, 0)
        
        XCTAssertEqual(sut.itemAtIndex(1).title, swift.title)
        XCTAssertEqual(sut.itemAtIndex(1).index, 1)
        
        XCTAssertEqual(sut.itemAtIndex(2).title, java.title)
        XCTAssertEqual(sut.itemAtIndex(2).index, 2)
    }
    
    func testMove_ItemMovedFromEndToTop() {
        sut.addItemAtTop(swift)
        sut.addItemAtTop(python)
        sut.addItemAtTop(java)
        // 0. java
        // 1. python
        // 2. swift
        XCTAssertEqual(sut.itemAtIndex(2).title, swift.title)
        XCTAssertEqual(sut.itemAtIndex(2).index, 2)
        sut.moveItem(from: 2, to: 0)
        // 0. swift
        // 1. java
        // 2. python
        XCTAssertEqual(sut.itemAtIndex(0).title, swift.title)
        XCTAssertEqual(sut.itemAtIndex(0).index, 0)
        
        XCTAssertEqual(sut.itemAtIndex(1).title, java.title)
        XCTAssertEqual(sut.itemAtIndex(1).index, 1)
        
        XCTAssertEqual(sut.itemAtIndex(2).title, python.title)
        XCTAssertEqual(sut.itemAtIndex(2).index, 2)
    }
    

    

}
