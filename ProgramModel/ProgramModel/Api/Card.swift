//
//  Card.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// A representation of a physical programming card.
///
/// A card contains various metadata that describes the connections it will allow and which it will require in a sequence of cards.
public protocol Card {
    var internalName: String { get }
    var type: CardType { get }
    var supportsParameter: Bool { get }
    var requiresParameter: Bool { get }
    var connectionAngles: [Double] { get }
}

public enum CardType {
    case control
    case action
    case parameter
}
