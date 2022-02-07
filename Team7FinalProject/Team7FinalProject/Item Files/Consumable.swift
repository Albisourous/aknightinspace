//
//  Consumable.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/8/21.
//

import UIKit

public class Consumable: NSObject, NSCoding {
    var count = 0
    var name: [String] = []
    var bonus: [Int] = []
    var bonusType: [String] = []
    
    init(count:Int, name:[String], bonus:[Int], bonusType:[String]) {
        self.count = count
        self.name = name
        self.bonus = bonus
        self.bonusType = bonusType
    }
    
    public override init() {
        super.init()
    }
    
    public required convenience init? (coder: NSCoder) {
        let count = coder.decodeInt32(forKey: "count")
        let name = coder.decodeObject(forKey: "name") as! [String]
        let bonus = coder.decodeObject(forKey: "bonus") as! [Int]
        let bonusType = coder.decodeObject(forKey: "bonusType") as! [String]
        
        self.init(count:Int(count), name:name, bonus:bonus, bonusType:bonusType)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.count, forKey: "count")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.bonus, forKey: "bonus")
        coder.encode(self.bonusType, forKey: "bonusType")
    }
    
    func add(name:String, bonus:Int, bonusType:String) {
        self.name.append(name)
        self.bonus.append(bonus)
        self.bonusType.append(bonusType)
        count += 1
    }
}
