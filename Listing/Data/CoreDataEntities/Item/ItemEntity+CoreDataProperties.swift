//
//  ItemEntity+CoreDataProperties.swift
//  Listing
//
//  Created by Johnny on 24/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var index: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var ofSubList: SubListEntity?

}

extension ItemEntity : Identifiable {

}
