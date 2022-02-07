//
//  GameMainScreenVC.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import UIKit
import SpriteKit

class GameMainScreenVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spaceman: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star6: UIImageView!
    @IBOutlet weak var star7: UIImageView!
    @IBOutlet weak var star8: UIImageView!
    @IBOutlet weak var star9: UIImageView!

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var player: Player!
    var settings: Settings!
    
    let queue = DispatchQueue.global()
    var remainingTime = 10
    var numEvents = 0
    var leave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
        
        do {
            try player = context.fetch(Player.fetchRequest())[0]
            try settings = context.fetch(Settings.fetchRequest())[0]
          }
          catch {
            print("No player")
          }
            
        updatePlayerData()
        
        animate()
        concurrentQueues()
        
        moveStar(curStar: star1)
        moveStar(curStar: star2)
        moveStar(curStar: star3)
        moveStar(curStar: star4)
        moveStar(curStar: star5)
        moveStar(curStar: star6)
        moveStar(curStar: star7)
        moveStar(curStar: star8)
        moveStar(curStar: star9)
    }
    
    func updatePlayerData() {
        nameLabel.text = "\(player.name!)\nLevel:\(player.xp/100)\nHP:\(player.hp)\nMana:\(player.mana)\nGold:\(player.gold)"
    }
    // Modified from
    //https://stackoverflow.com/questions/56253401/how-can-i-put-shake-animation-on-uiimageview
    // Gives animation
    func animate() {
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = 5
        anim.repeatCount = .infinity
        anim.autoreverses = true
        anim.fromValue = NSValue(cgPoint: CGPoint(x: spaceman.center.x, y: spaceman.center.y - 200))
        anim.toValue = NSValue(cgPoint: CGPoint(x: spaceman.center.x, y: spaceman.center.y))
        spaceman.layer.add(anim, forKey: "position")
    }
    
    func moveStar(curStar: UIImageView) {
        let yPos = CGFloat.random(in: 0.0...CGFloat(self.view.frame.height))
        let xPos = CGFloat.random(in: 100.0...300.0)
        let duration = TimeInterval.random(in: 2.0...5.0)
        
        curStar.center.x = self.view.frame.maxX + CGFloat(xPos)
        curStar.center.y = yPos
        
        UIView.animate(withDuration: duration, delay: 0, animations: {
            curStar.center.x = -CGFloat(xPos)
        }, completion: {_ in
            self.moveStar(curStar: curStar)
        })
    }
    
    // stop the counter if you are on another screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        leave = true
    }
    
    // to handle the multithreading every second
    func concurrentQueues() {
        queue.async{
            while(self.remainingTime > 0 && self.leave != true) {
                sleep(1)
                self.remainingTime -= 1
                print(self.remainingTime)
                DispatchQueue.main.async {
                    if(self.remainingTime == 0) {
                        self.popup()
                    }
                }
            }
        }
    }
    
    // popup the encounter every 10 seconds
    func popup() {
        let type:Int = Int.random(in: 1...100)
        if(settings.rumble) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        eventType(type: type)
        updatePlayerData()
    }
    
    // Handles all of the event types
    func eventType(type: Int) {
        let controller: UIAlertController
        if(type < 50) {
            controller = UIAlertController(title: "An event is occuring!", message: "Do you wish to go on this mission?", preferredStyle: .alert)
            
            // reject the mission
            controller.addAction(UIAlertAction(title: "No", style: .destructive, handler: {action in self.rejectMission()}))
            // accept the mission
            controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in self.acceptMission()}))
            
            present(controller, animated: true, completion: nil)
            
        }
        else if (type < 75) {
            let gold:Int = Int.random(in: 1...50)
            controller = UIAlertController(title: "An event is occuring!", message: "You have found " + String(gold) + " gold!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.rejectMission()}))
            self.present(controller, animated: true)
            player.gold += Int32(gold)
            savePlayerData()
        }
        else if (type < 85){
            let hp:Int = Int.random(in: 1...5)
            controller = UIAlertController(title: "An event is occuring!", message: "You have been healed for " + String(hp) + " health!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.rejectMission()}))
            self.present(controller, animated: true)
            player.hp += Int32(hp)
            if(player.hp > 100) {
                player.hp = 100
            }
            savePlayerData()
        }
        // TODO
        else {
            let xp:Int = Int.random(in: 50...200)
            controller = UIAlertController(title: "An event is occuring!", message: "You have trained and earned " + String(xp) + " xp!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.rejectMission()}))
            self.present(controller, animated: true)
            player.xp += Int32(xp)
        }
    }
    
    // start concurrency again if on the right screen
    func rejectMission() {
        self.remainingTime = 10
        if(!leave) {
            concurrentQueues()
        }
    }
    
    // segue into new screen depending on mission number
    func acceptMission() {
        self.remainingTime = 10
        numEvents += 1
        performSegue(withIdentifier: "EncounterSegue", sender: nil)
    }
    func savePlayerData() {
        do {
            try self.context.save()
            print("NewGame: Player has been created")
        }
        catch {
            print("NewGame: Player failed to be created")
        }
    }
    
    // continue concurrency even when you come back to the screen
    override func viewDidAppear(_ animated: Bool) {
        updatePlayerData()
        if(leave) {
            leave = false
            concurrentQueues()
            animate()
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}

