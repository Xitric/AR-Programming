//
//  ProgramDropInteractionDelegate.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 13/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class ProgramDropInteractionDelegate: NSObject, UIDropInteractionDelegate {
    
    private let serializer: CardGraphDeserializerProtocol
    
    init(serializer: CardGraphDeserializerProtocol) {
        self.serializer = serializer
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: DataItemProvider.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if let program = session.localDragSession?.localContext as? ProgramProtocol {
            print(program.start?.card.internalName)
            return
        }
        
        session.loadObjects(ofClass: DataItemProvider.self) { [weak self] results in
            if let result = results.first as? DataItemProvider,
                let self = self {
                let editor = try? self.serializer.deserialize(from: result.data)
                let program = editor?.allPrograms.first
                print(program?.start?.card.internalName)
            }
        }
    }
}
