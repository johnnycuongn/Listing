//
//  SubListEntity+CoreDataProperties.swift
//  Listing
//
//  Created by Johnny on 24/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//
//

import Foundation
import CoreData


extension SubListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubListEntity> {
        return NSFetchRequest<SubListEntity>(entityName: "SubListEntity")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var index: Int64
    @NSManaged public var title: String?
    @NSManaged public var items: NSSet?
    @NSManaged public var ofMainList: MainListEntity?

}

// MARK: Generated accessors for items
extension SubListEntity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension SubListEntity : Identifiable {

}
