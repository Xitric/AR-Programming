//
//  CardDatabase.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 16/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardDatabase {
    
    public var cards : [String:Card]
    
    init() {
        cards = [String:Card]()
        cards["StartD"] = Card(name: "Start", description: "Start description goes here", type: CardType.control)
        cards["MoveD"] = Card(name: "Move", description: "Use the Move card to make the robot take onestep in the direction it is facing.", type: CardType.action)
        cards["LeftD"] = Card(name: "Left", description: "Left description goes here", type: CardType.action)
        cards["RightD"] = Card(name: "Right", description: "Right description goes here", type: CardType.action)
        cards["JumpD"] = Card(name: "Jump", description: "Jump description goes here", type: CardType.action)
        cards["BranchD"] = Card(name: "Branch", description: "Branch description goes here", type: CardType.control)
    }
}
