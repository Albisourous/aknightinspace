//
//  NewGameVC.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/7/21.
//

import UIKit

class NewGameVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var classSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
        print("NewGame: Screen loaded successfully")
    }
    
    @IBAction func createPlayer(_ sender: Any) {
        deleteOldCharacter()
        
        let newPlayer = Player(context: self.context)
        if(nameTextField.text == "") {
            nameTextField.text = "Knight"
        }
        newPlayer.name = nameTextField.text
        newPlayer.gold = 0
        newPlayer.xp = 100
        newPlayer.hp = 100
        newPlayer.mana = 20
        if(nameTextField.text == "mark") {
            newPlayer.gold = 5000
        }
        if(nameTextField.text == "zac") {
            newPlayer.mana = 500
        }
        if(nameTextField.text == "connor") {
            newPlayer.xp = 5000
        }
        if(nameTextField.text == "albin") {
            newPlayer.hp = 1
        }
        addItems(player:newPlayer)
        do {
            try self.context.save()
            print("NewGame: Player has been created")
        }
        catch {
            print("NewGame: Player failed to be created")
        }
        
        print(newPlayer.weapons!.name[0])
        print(newPlayer.spells!.name[0])
        print(newPlayer.consumables!.name[0])
        
    }
    
    func deleteOldCharacter() {
        let corePlayers: Array<Player>!
        do {
            try corePlayers = context.fetch(Player.fetchRequest())
            if corePlayers.count > 0 {
                context.delete(corePlayers[0])
                print("NewGame: Old player data deleted")
            }
        }
        catch {
        }
    }
    
    func addItems(player:Player) {
        player.weapons = Weapon()
        player.spells = Spell()
        player.consumables = Consumable()

        let classNum = classSegmentedControl.selectedSegmentIndex
        if classNum == 0 {
            player.weapons!.add(name: "Axe", damage: 5)
        }
        if classNum == 1 {
            player.spells!.add(name:"Fire Ball", damage: 8, cost: 3)
        }
        if classNum == 2 {
            player.consumables!.add(name: "XP Potion", bonus: 10, bonusType: "xp")
        }
        player.weapons!.add(name: "Sword", damage: 3)
        player.weapons!.add(name: "Dagger", damage: 1)
        player.spells!.add(name:"Lightning Zap", damage: 4, cost: 2)
        player.spells!.add(name:"Air Blast", damage: 2, cost: 1)
        player.consumables!.add(name: "Health Potion", bonus: 5, bonusType: "health")
        player.consumables!.add(name: "Mana Potion", bonus: 5, bonusType: "mana")
    }
    
    // code to enable tapping on the background to remove software keyboard
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // code to enable tapping on the background to remove software keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
