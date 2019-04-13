//
//  ProgramDragInteractionDelegate.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 13/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class ProgramDragInteractionDelegate: NSObject, UIDragInteractionDelegate {
    
    private let serializer: CardGraphDeserializerProtocol
    
    var currentProgram: ProgramProtocol?
    
    init(serializer: CardGraphDeserializerProtocol) {
        self.serializer = serializer
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let currentProgram = currentProgram,
            let data = serializer.serialize(currentProgram) {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: DataItemProvider(data: data)))
            dragItem.localObject = currentProgram
            return [dragItem]
        }
        
        return []
    }
}
