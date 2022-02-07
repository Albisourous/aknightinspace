//
//  Player+CoreDataProperties.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/11/21.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var consumables: Consumable?
    @NSManaged public var gold: Int32
    @NSManaged public var mana: Int32
    @NSManaged public var name: String?
    @NSManaged public var spells: Spell?
    @NSManaged public var weapons: Weapon?
    @NSManaged public var xp: Int32
    @NSManaged public var hp: Int32

}

extension Player : Identifiable {

}
