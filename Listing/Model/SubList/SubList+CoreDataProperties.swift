//
//  SubList+CoreDataProperties.swift
//  Listing
//
//  Created by Johnny on 24/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//
//

import Foundation
import CoreData


extension SubList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubList> {
        return NSFetchRequest<SubList>(entityName: "SubList")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var title: String?
    @NSManaged public var index: Int64
    @NSManaged public var ofMainList: MainList?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension SubList {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
