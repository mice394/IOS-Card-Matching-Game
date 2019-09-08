//
//  SoundManager.swift
//  MatchGame
//
//  Created by Emily Shao on 2019-09-08.
//  Copyright © 2019 Emily Shao. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFilename = ""
        
        // Determine which sound effect to play with file name
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        // Get path of sound file inside bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file: \(soundFilename) in bundle")
            return
        }
        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Plays sound
            audioPlayer?.play()
        }
        catch {
            // Couldn't create audio player object, log error
            print("Couldn't create the audio player object for sound file: \(soundFilename)")
        }
        
    }
}
