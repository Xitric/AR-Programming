//
//  ProgramEditorViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 14/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ProgramModel

class ProgramEditorViewModel: ProgramEditorViewModeling, ProgramEditorDelegate {
    
    let editedProgram = ObservableProperty<ProgramProtocol?>()
    let editedCards = ObservableProperty<[CardNodeProtocol]>([CardNodeProtocol]())
    
    private var editor: ProgramEditorProtocol
    
    init(editor: ProgramEditorProtocol) {
        self.editor = editor
        self.editor.delegate = self
    }
    
    //MARK: - ProgramEditorDelegate
    func programEditor(_ programEditor: ProgramEditorProtocol, createdNew program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.editedProgram.value = program
            self?.editedCards.value = self!.editor.allCards
        }
    }
    
    //MARK: - FrameDelegate
    func frameScanner(_ scanner: ARController, didUpdate frame: CVPixelBuffer, withOrientation orientation: CGImagePropertyOrientation) {
        editor.newFrame(frame,
                        oriented: orientation,
                        frameWidth: Double(UIScreen.main.bounds.width),
                        frameHeight: Double(UIScreen.main.bounds.height))
    }
}

protocol ProgramEditorViewModeling: FrameDelegate {
    
    var editedProgram: ObservableProperty<ProgramProtocol?> { get }
    var editedCards: ObservableProperty<[CardNodeProtocol]> { get }
}
