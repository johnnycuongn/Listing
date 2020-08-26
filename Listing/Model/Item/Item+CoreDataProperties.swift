//
//  Item+CoreDataProperties.swift
//  Listing
//
//  Created by Johnny on 27/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var index: Int64
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var ofSubList: SubList?

}
