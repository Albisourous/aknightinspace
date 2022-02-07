//
//  ShopVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit

class ShopVC: UIViewController {

    
    @IBOutlet weak var itemText1: UILabel!
    @IBOutlet weak var itemText2: UILabel!
    @IBOutlet weak var itemText3: UILabel!
    @IBOutlet weak var shopkeeper: UIImageView!
    @IBOutlet weak var dialogue: UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var corePlayer: Player!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
        
        do {
          try corePlayer = context.fetch(Player.fetchRequest())[0]
        }
        catch {
        }
        changeTexts()
    }
    
    func changeTexts() {
        self.dialogue.text = "Hello \(corePlayer.name ?? "adventurer")! Welcome to my shop!\nYou currently have \(corePlayer.gold) gold."
        self.itemText1.text = "Steak\n230 gold\nA nice juicy piece of meat"
        self.itemText2.text = "Cola\n200 gold\nA refreshing and cold soda"
        self.itemText3.text = "Golden Apple\n380 gold\nThis apple shines like the morning sun"
    }
    
    @IBAction func purchaseItem1(_ sender: Any) {
        if(corePlayer.gold >= 230) {
            corePlayer.gold = corePlayer.gold - 230
            corePlayer.consumables!.add(name: "Steak", bonus: 7, bonusType: "health")
            self.dialogue.text = "Thanks for purchasing! You now have\n\(corePlayer.gold) gold remaining."
        } else {
            self.dialogue.text = "Sorry. You do not have enough gold to \npurchase this! You have \(corePlayer.gold) gold."
        }
    }
    
    @IBAction func purchaseItem2(_ sender: Any) {
        if(corePlayer.gold >= 200) {
            corePlayer.gold = corePlayer.gold - 200
            corePlayer.consumables!.add(name: "Cola", bonus: 6, bonusType: "mana")
            self.dialogue.text = "Thanks for purchasing! You now have\n\(corePlayer.gold) gold remaining."
        } else {
            self.dialogue.text = "Sorry. You do not have enough gold to \npurchase this! You have \(corePlayer.gold) gold."
        }
    }
    
    @IBAction func purchaseItem3(_ sender: Any) {
        if(corePlayer.gold >= 380) {
            corePlayer.gold = corePlayer.gold - 380
            corePlayer.consumables!.add(name: "Golden Apple", bonus: 15, bonusType: "xp")
            self.dialogue.text = "Thanks for purchasing! You now have\n\(corePlayer.gold) gold remaining."
        } else {
            self.dialogue.text = "Sorry. You do not have enough gold to \npurchase this! You have \(corePlayer.gold) gold."
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        savePlayerData()
    }
    
    func savePlayerData() {
            do {
                try self.context.save()
                print("Item bought")
            }
            catch {
                print("Item error in buying")
            }
        }
}
