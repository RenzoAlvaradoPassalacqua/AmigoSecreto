//
//  Person+CoreDataProperties.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/15/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var admin: Bool
    @NSManaged public var email: String?
    @NSManaged public var gift: String?
    @NSManaged public var logged: Bool
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var state: String?
    @NSManaged public var drawPersonA: NSSet?
    @NSManaged public var drawPersonB: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var players: Event?

}

// MARK: Generated accessors for drawPersonA
extension Person {

    @objc(addDrawPersonAObject:)
    @NSManaged public func addToDrawPersonA(_ value: Draw)

    @objc(removeDrawPersonAObject:)
    @NSManaged public func removeFromDrawPersonA(_ value: Draw)

    @objc(addDrawPersonA:)
    @NSManaged public func addToDrawPersonA(_ values: NSSet)

    @objc(removeDrawPersonA:)
    @NSManaged public func removeFromDrawPersonA(_ values: NSSet)

}

// MARK: Generated accessors for drawPersonB
extension Person {

    @objc(addDrawPersonBObject:)
    @NSManaged public func addToDrawPersonB(_ value: Draw)

    @objc(removeDrawPersonBObject:)
    @NSManaged public func removeFromDrawPersonB(_ value: Draw)

    @objc(addDrawPersonB:)
    @NSManaged public func addToDrawPersonB(_ values: NSSet)

    @objc(removeDrawPersonB:)
    @NSManaged public func removeFromDrawPersonB(_ values: NSSet)

}

// MARK: Generated accessors for events
extension Person {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
