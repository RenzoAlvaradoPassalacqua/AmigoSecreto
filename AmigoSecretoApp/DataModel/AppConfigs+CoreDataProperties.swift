//
//  AppConfigs+CoreDataProperties.swift
//  AmigoSecretoApp
//
//  Created by Renzo Manuel Alvarado Passalacqua on 2/8/19.
//  Copyright © 2019 Renzo Manuel Alvarado Passalacqua. All rights reserved.
//
//

import Foundation
import CoreData


extension AppConfigs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppConfigs> {
        return NSFetchRequest<AppConfigs>(entityName: "AppConfigs")
    }

    @NSManaged public var appCurrentDate: NSDate?
    @NSManaged public var appName: String?
    @NSManaged public var appSubtitle: String?
    @NSManaged public var id: Int16
    @NSManaged public var isEventActive: Bool
    @NSManaged public var isLogged: Bool
    @NSManaged public var adminUser: Person?
    @NSManaged public var currentappLoggedUser: Person?

}
