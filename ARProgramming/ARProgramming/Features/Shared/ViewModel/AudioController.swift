//
//  AudioController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 23/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
    
    public func makeSound(withName name: String) -> AVAudioPlayer? {
        if let soundUrl = Bundle.main.url(forResource: name, withExtension: "") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: soundUrl) {
                audioPlayer.prepareToPlay()
                return audioPlayer
            }
        }
        print("Error: Could not read sound file with name \(name)")
        return nil
    }
}
