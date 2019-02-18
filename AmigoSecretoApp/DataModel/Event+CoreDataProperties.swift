//
//  Event+CoreDataProperties.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/18/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var date: String?
    @NSManaged public var maxprice: String?
    @NSManaged public var minprice: String?
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var draw: NSSet?
    @NSManaged public var owner: Person?
    @NSManaged public var players: NSSet?

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

// MARK: Generated accessors for players
extension Event {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Person)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Person)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}
