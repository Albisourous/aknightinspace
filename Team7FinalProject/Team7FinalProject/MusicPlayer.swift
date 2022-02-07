//
//  MusicPlayer.swift
//  Team7FinalProject
//
//  Created by Zac Galer on 8/8/21.
//

import Foundation
import AVFoundation

import AVFoundation

class MusicPlayer {
    
    static let sharedHelper = MusicPlayer()
    var audioPlayer: AVAudioPlayer?

    func playBackgroundMusic() {
        
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Corona-320bit", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
}
