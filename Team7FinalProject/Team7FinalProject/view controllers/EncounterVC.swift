//
//  EncounterVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit

protocol WeaponAttack {
    func weaponAtk(weaponDamage:Int)
}

protocol SpellAttack {
    func spellAtk(spellDamage:Int, spellMana:Int)
}

protocol UseItem {
    func useItem(value:Int, stat:String)
}

class EncounterVC: UIViewController, WeaponAttack, SpellAttack, UseItem {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var player: Player!
    var settings: Settings!
    
    @IBOutlet weak var enemyImage: UIImageView!
    @IBOutlet weak var enemyInfo: UILabel!
    @IBOutlet weak var playerInfo: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    var slimeHP:Int = 0
    var slimeDamage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Encounter!")
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
        
        do {
            try player = context.fetch(Player.fetchRequest())[0]
            try settings = context.fetch(Settings.fetchRequest())[0]
        }
        catch {
            print("No player")
        }
        actionLabel.text = "A wild Slime has appeared!"
        updatePlayerData()
        generateSlime()
    }
    
    func updatePlayerData() {
        playerInfo.text = "\(player.name!)\nLevel:\(player.xp/100)\nHP:\(player.hp)\nMana:\(player.mana)\nGold:\(player.gold)"
    }
    
    func updateSlimeData() {
        enemyInfo.text = "Slime\nHP: " + String(slimeHP) + "\nDamage: " + String(slimeDamage)
    }
    
    func slimeAttack() {
        player.hp -= Int32(slimeDamage)
        if(player.hp <= 0) {
            // Your player has died
            // Segue to new player menu
            defeat()
        }
        if(settings.rumble) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        updatePlayerData()
    }
    
    func generateSlime() {
        if(slimeHP == 0) {
            slimeHP = Int.random(in: 10...50)
        }
        if (slimeDamage == 0) {
            slimeDamage = Int.random(in: 3...5)
        }
        updateSlimeData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WeaponSegue",
           let nextVC = segue.destination as? AttackVC {
            nextVC.delegate = self
        }
        if segue.identifier == "SpellSegue",
           let nextVC = segue.destination as? CastVC {
            nextVC.delegate = self
        }
        if segue.identifier == "ItemSegue",
           let nextVC = segue.destination as? ItemVC {
            nextVC.delegate = self
        }
    }
    
    func weaponAtk(weaponDamage: Int) {
        slimeHP -= weaponDamage + Int(player.xp/100)
        if(slimeHP <= 0) {
            victory()
        }
        else {
            fightAnimation()
        }
        if(settings.rumble) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        updateSlimeData()
        slimeAttack()
        actionLabel.text = "\(player.name!) did \(weaponDamage + Int(player.xp/100)) damage to Slime!\nSlime did \(slimeDamage) to \(player.name!)!"
    }
    
    func spellAtk(spellDamage: Int, spellMana: Int) {
        let playerAttacked = spellMana <= player.mana
        if(playerAttacked) {
            slimeHP -= spellDamage + 2*(Int(player.xp/100))
            player.mana -= Int32(spellMana)
            updateSlimeData()
        }
        if(slimeHP <= 0) {
            victory()
        }
        else {
            fightAnimation()
        }
        if(settings.rumble) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        slimeAttack()
        if(playerAttacked) {
            actionLabel.text = "\(player.name!) did \(spellDamage + Int(player.xp/100)) damage to Slime!\n\(player.name!) used \(spellMana) mp to cast the spell!\nSlime did \(slimeDamage) to \(player.name!)!"
        } else {
            actionLabel.text = "\(player.name!) did not have enough mana to do anything!\nSlime did \(slimeDamage) to \(player.name!)!"
        }
        updatePlayerData()
    }
    
    func useItem(value: Int, stat: String) {
        print(stat)
        if(stat == "health") {
            player.hp += Int32(value)
            if(player.hp > 100) {
                player.hp = 100
            }
        } else if(stat == "mana") {
            player.mana += Int32(value)
            if(player.mana > 100) {
                player.mana = 100
            }
        } else if(stat == "xp") {
            player.xp += Int32(value)
        }
        fightAnimation()
        updateSlimeData()
        updatePlayerData()
        actionLabel.text = "\(player.name!) gained \(value) in \(stat)!"
    }
    
    func victory() {
        let xpGain = Int.random(in: 75...250)
        let goldGain = Int.random(in: 75...250)
        player.xp += Int32(xpGain)
        player.gold += Int32(goldGain)
        updatePlayerData()
        actionLabel.text = "You have won the battle!"
        let controller = UIAlertController(title: "You won the fight! You gained " + String(xpGain) + " xp and " + String(goldGain) + " gold!", message: nil, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.performSegue(withIdentifier: "RetreatSegue", sender: nil)}))
        self.present(controller, animated: true)
        // segueback to main
    }
    
    func defeat() {
        actionLabel.text = "You have lost the battle!"
        let controller = UIAlertController(title: "You lost the fight! Better luck next time!", message: nil, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.performSegue(withIdentifier: "DefeatSegue", sender: nil)}))
        self.present(controller, animated: true)
        // segueback to new character
    }
    
    func fightAnimation() {
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = 5
        anim.repeatCount = 2
        anim.autoreverses = true
        anim.fromValue = NSValue(cgPoint: CGPoint(x: enemyImage.center.x - 10, y: enemyImage.center.y))
        anim.toValue = NSValue(cgPoint: CGPoint(x: enemyImage.center.x + 10, y: enemyImage.center.y))
        enemyImage.layer.add(anim, forKey: "position")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
