//
//  CastVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit

class CastVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var delegate: EncounterVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
        do {
          try corePlayer = context.fetch(Player.fetchRequest())[0]
        }
        catch {
        }
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var corePlayer: Player!
    let textCellIdentifier = "TextCell"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = "\n\(corePlayer.spells!.name[row])\n"
        cell.detailTextLabel?.text = "Damage: \(corePlayer.spells!.damage[row])\n\nCost: \(corePlayer.spells!.cost[row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corePlayer.spells!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = navigationController?.popViewController(animated: true)
        let damage = corePlayer.spells!.damage[indexPath.row]
        let mana = corePlayer.spells!.cost[indexPath.row]
        let otherVC = delegate!
        otherVC.spellAtk(spellDamage: damage, spellMana: mana)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
