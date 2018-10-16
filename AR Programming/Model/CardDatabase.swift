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
        cards["Start"] = Card(name: "Start", description: "Use the Start card to indicate where the program starts. Whenever the program is executed, it will begin at this card.", type: CardType.control)
        cards["Move"] = Card(name: "Move", description: "Use the Move card to make the robot take one step in the direction it is facing. To change the orientation of the robot, use one of the Rotation cards.", type: CardType.action)
        cards["Left"] = Card(name: "Left", description: "Use the Left card to rotate the robot to the left, that is 90 degrees counterclockwise.", type: CardType.action)
        cards["Right"] = Card(name: "Right", description: "Use the Right card to rotate the robot to the right, that is 90 degrees clockwise.", type: CardType.action)
        cards["Jump"] = Card(name: "Jump", description: "Use the Jump card to make the robot jump in place.", type: CardType.action)
        cards["Branch"] = Card(name: "Branch", description: "Use the Branch card to make the program capable of doing different things depending on a condition.", type: CardType.control)
    }
}
