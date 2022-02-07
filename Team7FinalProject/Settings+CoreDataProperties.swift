//
//  Settings+CoreDataProperties.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/7/21.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var rumble: Bool
    @NSManaged public var sound: Bool

}

extension Settings : Identifiable {

}
