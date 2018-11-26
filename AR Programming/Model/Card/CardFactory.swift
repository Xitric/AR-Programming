//
//  CardFactory.swift
//  AR Programming
//
//  Created by user143563 on 11/4/18.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardFactory {
    
    static var instance = CardFactory();
    var cardLibrary: [Card] = []
    var cards : [String:Card]
    
    init() {
        cards = [String:Card]()
        addCard(Card(name: "Start", description: "Use the Start card to indicate where the program starts. Whenever the program is executed, it will begin at this card.", type: CardType.control, command: nil))
        
        addCard(Card(name: "Move", description: "Use the Move card to make the robot take one step in the direction it is facing. To change the orientation of the robot, use one of the Rotation cards.", type: CardType.action, command: MoveCommand()))
        
        addCard(Card(name: "Left", description: "Use the Left card to rotate the robot to the left, that is 90 degrees counterclockwise.", type: CardType.action, command: LeftCommand()))
        
        addCard(Card(name: "Right", description: "Use the Right card to rotate the robot to the right, that is 90 degrees clockwise.", type: CardType.action, command: RightCommand()))
        
        addCard(Card(name: "Jump", description: "Use the Jump card to make the robot jump in place.", type: CardType.action, command: JumpCommand()))
        
        addCard(Card(name: "Branch", description: "Use the Branch card to make the program capable of doing different things depending on a condition.", type: CardType.control, command: nil))
    }
    
    private func addCard(_ card: Card) {
        cards[card.name.lowercased()] = card
        cardLibrary.append(card)
    }
    
    public func getCard(named name: String) -> Card? {
        return cards[name.lowercased()]
    }
}
