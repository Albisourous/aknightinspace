//
//  Spell.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/8/21.
//

import UIKit

public class Spell: NSObject, NSCoding {
    var count = 0
    var name: [String] = []
    var damage: [Int] = []
    var cost: [Int] = []
    
    init(count:Int, name:[String], damage:[Int], cost:[Int]) {
        self.count = count
        self.name = name
        self.damage = damage
        self.cost = cost
    }
    
    public override init() {
        super.init()
    }
    
    public required convenience init? (coder: NSCoder) {
        let count = coder.decodeInt32(forKey: "count")
        let name = coder.decodeObject(forKey: "name") as! [String]
        let damage = coder.decodeObject(forKey: "damage") as! [Int]
        let cost = coder.decodeObject(forKey: "cost") as! [Int]
        
        self.init(count:Int(count), name:name, damage:damage, cost:cost)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.count, forKey: "count")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.damage, forKey: "damage")
        coder.encode(self.cost, forKey: "cost")
    }
    
    func add(name:String, damage:Int, cost:Int) {
        self.name.append(name)
        self.damage.append(damage)
        self.cost.append(cost)
        count += 1
    }
}
