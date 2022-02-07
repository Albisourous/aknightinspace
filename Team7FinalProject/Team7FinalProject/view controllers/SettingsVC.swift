//
//  SettingsVC.swift
//  Team7FinalProject
//
//  Created by Connor Kite on 8/7/21.
//

import UIKit
import AVFoundation

var soundFlag = true

class SettingsVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var settings: Settings!
    
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var rumbleButton: UIButton!
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "A_Knight_in_Space_Default.jpg")!)
        if settings != nil {
            print("Settings: Screen loaded successfully")
        } else {
            findSettings()
        }
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        updateSound()
        updateRumble()
    }
    
    func findSettings() {
        while settings == nil{
            let coreSettings: Array<Settings>!
            do {
                try coreSettings = context.fetch(Settings.fetchRequest())
                if coreSettings.count < 1 {
                    print("Home: No settings found")
                    initSettings()
                } else {
                    settings = coreSettings[0]
                }
            }
            catch {
            }
        }
    }
    
    func initSettings() {
        let newSettings = Settings(context: self.context)
        newSettings.sound = true
        newSettings.rumble = true
        do {
            try self.context.save()
        }
        catch {
            print("Home: Settings failed to initialize")
        }
    }
    
    //
    func updateSound() {
        soundButton.setTitle("Sound: \(settings.sound ? "On" : "Off")", for: .normal)
        if(settings.rumble) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    //
    func updateRumble() {
        rumbleButton.setTitle("Rumble: \(settings.rumble ? "On" : "Off")", for: .normal)
        if(settings.rumble) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    //
    @IBAction func soundPressed(_ sender: Any) {
        //set sound to the opposite of what it is
        settings.sound = !settings.sound
        do {
            try self.context.save()
            print("Settings: Sound updated to \(settings.sound)")
        }
        catch {
            print("Settings: Sound failed to update")
        }
        
        // turn sound on/off depending on previous setting
        if soundButton.titleLabel!.text == "Sound: On" {
            soundFlag = false
            MusicPlayer.sharedHelper.stopMusic()
        }
        else {
            soundFlag = true
            MusicPlayer.sharedHelper.playBackgroundMusic()
        }
        
        //change the name of the sound button to the new status
        updateSound()
    }
    
    //
    @IBAction func rumblePressed(_ sender: Any) {
        //set rumble to the opposite of what it is
        settings.rumble = !settings.rumble
        do {
            try self.context.save()
            print("Settings: Rumble updated to \(settings.rumble)")
        }
        catch {
            print("Settings: Rumble failed to update")
        }
        //change the name of the rumble button to the new status
        updateRumble()
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
