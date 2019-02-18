//
//  Draw+CoreDataProperties.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/18/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//
//

import Foundation
import CoreData


extension Draw {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Draw> {
        return NSFetchRequest<Draw>(entityName: "Draw")
    }

    @NSManaged public var date: String?
    @NSManaged public var gift: String?
    @NSManaged public var state: String?
    @NSManaged public var event: Event?
    @NSManaged public var friendShipA: NSSet?
    @NSManaged public var friendShipB: NSSet?

}

// MARK: Generated accessors for friendShipA
extension Draw {

    @objc(addFriendShipAObject:)
    @NSManaged public func addToFriendShipA(_ value: Person)

    @objc(removeFriendShipAObject:)
    @NSManaged public func removeFromFriendShipA(_ value: Person)

    @objc(addFriendShipA:)
    @NSManaged public func addToFriendShipA(_ values: NSSet)

    @objc(removeFriendShipA:)
    @NSManaged public func removeFromFriendShipA(_ values: NSSet)

}

// MARK: Generated accessors for friendShipB
extension Draw {

    @objc(addFriendShipBObject:)
    @NSManaged public func addToFriendShipB(_ value: Person)

    @objc(removeFriendShipBObject:)
    @NSManaged public func removeFromFriendShipB(_ value: Person)

    @objc(addFriendShipB:)
    @NSManaged public func addToFriendShipB(_ values: NSSet)

    @objc(removeFriendShipB:)
    @NSManaged public func removeFromFriendShipB(_ values: NSSet)

}
