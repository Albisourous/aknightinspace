//
//  ViewController.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 7/22/21.
//

import UIKit
import UserNotifications
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var settings: Settings!
    var player: AVAudioPlayer?  //declare in code

    
    // for local notifications
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for local notifications
        self.requestNotificationAuthorization()
        self.sendPlayNotification()
        self.sendXPNotification()
        self.sendGoldNotification()

        // Edits the navigation bar color and transluscence
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A Knight in Space Title.jpg")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "A Knight in Space Title.jpg")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        
        findSettings()
        findPlayer()
        print("Home: Screen loaded successfully")
        playMusic()
    }
    
    // for local notification
    // asks for user permissions
    func requestNotificationAuthorization() {
        // Auth options
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    // for local notifications
    // sends notification
    func sendPlayNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Your Knight Needs YOU!"
        notificationContent.body = "Your Knight is being attacked! Come to it's aid!"
        notificationContent.badge = NSNumber(value: 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    // sends notification about receiving gold
    func sendGoldNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Your Knight is Making Money!"
        notificationContent.body = "You Just Got Gold. Time To Visit the Shop?"
        notificationContent.badge = NSNumber(value: 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    // sends notification about receiving XP
    func sendXPNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Your Knight is Leveling Up!"
        notificationContent.body = "You Just Got XP. Time to Fight Stronger Monsters!"
        notificationContent.badge = NSNumber(value: 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    // starts background music
    func playMusic() {
        if settings == nil {
            MusicPlayer.sharedHelper.playBackgroundMusic()
        }
        else {
            if settings.sound == true {
                MusicPlayer.sharedHelper.playBackgroundMusic()
            }
        }
    }
    
    //
    func findPlayer(){
        print("Home: Looking player data")
        let corePlayers: Array<Player>!
        do {
            try corePlayers = context.fetch(Player.fetchRequest())
            if corePlayers.count < 1 {
                print("Home: No previous player data found")
                continueButton.isEnabled = false
            } else {
                print("Home: Found previous player save data")
            }
        }
        catch {
        }
    }
    
    //
    func findSettings() {
        while settings == nil{
            print("Home: Looking for settings")
            let coreSettings: Array<Settings>!
            do {
                try coreSettings = context.fetch(Settings.fetchRequest())
                if coreSettings.count < 1 {
                    print("Home: No settings found")
                    initSettings()
                } else {
                    settings = coreSettings[0]
                    print("Home: Settings were found successfully")
                }
            }
            catch {
            }
        }
    }
    
    //
    func initSettings() {
        let newSettings = Settings(context: self.context)
        newSettings.sound = true
        newSettings.rumble = true
        do {
            try self.context.save()
            print("Home: Settings have been initialized")
        }
        catch {
            print("Home: Settings failed to initialize")
        }
    }
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToSettings" {
            let destination = segue.destination as! SettingsVC
            destination.settings = settings
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
