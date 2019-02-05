//
//  CardMapper.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardMapper {
    
    func getCard(identifier: Int) -> Card?
}
