//
//  MainList+CoreDataProperties.swift
//  Listing
//
//  Created by Johnny on 24/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//
//

import Foundation
import CoreData


extension MainList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainList> {
        return NSFetchRequest<MainList>(entityName: "MainList")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var title: String?
    @NSManaged public var index: Int64
    @NSManaged public var subLists: NSSet?

}

// MARK: Generated accessors for subLists
extension MainList {

    @objc(addSubListsObject:)
    @NSManaged public func addToSubLists(_ value: SubList)

    @objc(removeSubListsObject:)
    @NSManaged public func removeFromSubLists(_ value: SubList)

    @objc(addSubLists:)
    @NSManaged public func addToSubLists(_ values: NSSet)

    @objc(removeSubLists:)
    @NSManaged public func removeFromSubLists(_ values: NSSet)

}
