//
//  WeaponsVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit

class WeaponsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
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
        cell.textLabel?.text = "\n\(corePlayer.weapons!.name[row])\n"
        cell.detailTextLabel?.text = "\nDamage: \(corePlayer.weapons!.damage[row])\n"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corePlayer.weapons!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
