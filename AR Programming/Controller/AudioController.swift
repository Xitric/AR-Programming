//
//  AudioController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 23/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import AudioKit

//Inspired by:
//https://github.com/AudioKit/AudioKit/blob/master/Examples/macOS/FlangerAndChorus/FlangerAndChorus/Conductor.swift
class AudioController {
    
    static let instance = AudioController()
    
    private init(){
        
    }
    
    public func makeSound(withName name: String) -> AKAudioPlayer? {
        if let soundFile = try? AKAudioFile(readFileName: name) {
            if let player = try? AKAudioPlayer(file: soundFile) {
                player.looping = false
                AudioKit.output = player
                
                return player
            }
        }
        
        print("Error: Could not read sound file with name \(name)")
        return nil
    }
    
    public func start() {
        do {
            try AudioKit.start()
        } catch {
            print("Error: AudioKit was unable to start")
        }
    }
    
    public func stop() {
        do {
            try AudioKit.stop()
        } catch {
            print("Error: AudioKit was unable to stop")
        }
    }
}
