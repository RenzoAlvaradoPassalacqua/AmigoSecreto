//
//  Event+CoreDataProperties.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/6/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var minprice: String?
    @NSManaged public var maxprice: String?
    @NSManaged public var state: String?
    @NSManaged public var owner: Person?
    @NSManaged public var draw: NSSet?

}

// MARK: Generated accessors for draw
extension Event {

    @objc(addDrawObject:)
    @NSManaged public func addToDraw(_ value: Draw)

    @objc(removeDrawObject:)
    @NSManaged public func removeFromDraw(_ value: Draw)

    @objc(addDraw:)
    @NSManaged public func addToDraw(_ values: NSSet)

    @objc(removeDraw:)
    @NSManaged public func removeFromDraw(_ values: NSSet)

}
