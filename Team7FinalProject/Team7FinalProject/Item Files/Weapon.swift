//
//  Weapon.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/8/21.
//

import UIKit

public class Weapon: NSObject, NSCoding {
    var count = 0
    var name: [String] = []
    var damage: [Int] = []
    
    init(count:Int, name:[String], damage:[Int]) {
        self.count = count
        self.name = name
        self.damage = damage
    }
    
    public override init() {
        super.init()
    }
    
    public required convenience init? (coder: NSCoder) {
        let count = coder.decodeInt32(forKey: "count")
        let name = coder.decodeObject(forKey: "name") as! [String]
        let damage = coder.decodeObject(forKey: "damage") as! [Int]
        
        self.init(count:Int(count), name:name, damage:damage)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.count, forKey: "count")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.damage, forKey: "damage")
    }
    
    public func add(name:String, damage:Int) {
        self.name.append(name)
        self.damage.append(damage)
        count += 1
    }
}
