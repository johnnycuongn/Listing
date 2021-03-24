//
//  MainListEntity+CoreDataProperties.swift
//  Listing
//
//  Created by Johnny on 24/3/21.
//  Copyright © 2021 Johnny. All rights reserved.
//
//

import Foundation
import CoreData


extension MainListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainListEntity> {
        return NSFetchRequest<MainListEntity>(entityName: "MainListEntity")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var index: Int64
    @NSManaged public var title: String?
    @NSManaged public var subLists: NSSet?

}

// MARK: Generated accessors for subLists
extension MainListEntity {

    @objc(addSubListsObject:)
    @NSManaged public func addToSubLists(_ value: SubListEntity)

    @objc(removeSubListsObject:)
    @NSManaged public func removeFromSubLists(_ value: SubListEntity)

    @objc(addSubLists:)
    @NSManaged public func addToSubLists(_ values: NSSet)

    @objc(removeSubLists:)
    @NSManaged public func removeFromSubLists(_ values: NSSet)

}

extension MainListEntity : Identifiable {

}
