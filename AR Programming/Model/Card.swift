//
//  CardModel.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 16/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct Card {
    
    public var name : String
    public var description : String
    public var type : CardType
}

enum CardType {
    case action
    case control
}
