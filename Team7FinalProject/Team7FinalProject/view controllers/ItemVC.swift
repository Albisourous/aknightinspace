//
//  ItemVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit

class ItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var delegate: EncounterVC!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var corePlayer: Player!
    let textCellIdentifier = "TextCell"
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = "\n\(corePlayer.consumables!.name[row])\n"
        cell.detailTextLabel?.text = "\nGain \(corePlayer.consumables!.bonus[row]) \(corePlayer.consumables!.bonusType[row])\n"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corePlayer.consumables!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = navigationController?.popViewController(animated: true)
        let bonus = corePlayer.consumables!.bonus[indexPath.row]
        let bonusType = corePlayer.consumables!.bonusType[indexPath.row]
        let otherVC = delegate!
        otherVC.useItem(value: bonus, stat: bonusType)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
