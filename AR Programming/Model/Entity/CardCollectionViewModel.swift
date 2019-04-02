//
//  CardCollectionViewModel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardCollectionViewModel {
    
    private var cards = [CardType:[Card]]()
    
    var numberOfTypes: Int {
        return cards.count
    }
    
    var cardTypes: [CardType] {
        //Return card types in a specific order since the order returned from the model is arbitrary
        return [.action, .control, .parameter].filter {
            cards.keys.contains($0)
        }
    }
    
    init(cards: [Card]) {
        for card in cards {
            let cardType = card.type
            var typeArray = self.cards[cardType] ?? [Card]()
            typeArray.append(card)
            self.cards[cardType] = typeArray
        }
    }
    
    func numberOfCards(ofType type: CardType) -> Int {
        return cards[type]?.count ?? 0
    }
    
    func cards(ofType type: CardType) -> [Card] {
        if let cardsToReturn = cards[type] {
            return cardsToReturn.sorted {
                return $0.internalName < $1.internalName
            }
        }
        
        return [Card]()
    }
    
    func displayName(ofType type: CardType) -> String {
        switch type {
        case .action:
            return "Handlinger"
        case .control:
            return "Kontrol"
        case .parameter:
            return "Talkort"
        }
    }
}
