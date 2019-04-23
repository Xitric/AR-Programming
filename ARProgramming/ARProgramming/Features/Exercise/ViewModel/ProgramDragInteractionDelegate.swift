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
    
    private var dragPreviewView: UIView {
        let functionView = FunctionView()
        functionView.program = currentProgram
        functionView.backgroundColor = .clear
        return functionView
    }
    
    private var dragPreviewParams: UIDragPreviewParameters {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        return params
    }
    
    var currentProgram: ProgramProtocol?
    
    init(serializer: CardGraphDeserializerProtocol) {
        self.serializer = serializer
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let currentProgram = currentProgram,
            let data = serializer.serialize(currentProgram) {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: DataItemProvider(data: data)))
            dragItem.localObject = currentProgram
            
            let view = dragPreviewView
            let params = dragPreviewParams
            
            dragItem.previewProvider = {
                return UIDragPreview(view: view, parameters: params)
            }
            
            return [dragItem]
        }
        
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        if let view = interaction.view {
            let target = UIDragPreviewTarget(container: view,
                                             center: session.location(in: view))
            return UITargetedDragPreview(view: dragPreviewView, parameters: dragPreviewParams, target: target)
        }
        
        return nil
    }
}
