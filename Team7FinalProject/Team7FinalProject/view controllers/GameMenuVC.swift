//
//  GameMenuVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit

class GameMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)

    }
    
    @IBAction func exitGame(_ sender: Any) {
        exit(0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
