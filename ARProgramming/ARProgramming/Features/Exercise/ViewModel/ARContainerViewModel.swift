//
//  ARContainerViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ProgramModel

/// View model that is responsible for updating the current level, updating the card scanner, and sending back information about which cards and programs are currently detected.
class ARContainerViewModel: ARContainerViewModeling, ProgramEditorDelegate {

    private var editor: ProgramEditorProtocol
    private let levelContainer: CurrentLevelProtocol
    private let _editedProgram = ObservableProperty<ProgramProtocol?>()
    private let _editedCards = ObservableProperty<[CardNodeProtocol]>([])
    let arController: ARController

    var editedProgram: ImmutableObservableProperty<ProgramProtocol?> {
        return _editedProgram
    }
    var editedCards: ImmutableObservableProperty<[CardNodeProtocol]> {
        return _editedCards
    }

    init(editor: ProgramEditorProtocol, level: CurrentLevelProtocol, arController: ARController) {
        self.editor = editor
        self.levelContainer = level
        self.arController = arController

        self.editor.delegate = self
        self.arController.updateDelegate = self
        self.arController.frameDelegate = self
    }

    func start() {
        arController.start()
    }

    func stop() {
        arController.stop()
    }

    // MARK: - ProgramEditorDelegate
    func programEditor(_ programEditor: ProgramEditorProtocol, createdNew program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?._editedProgram.value = program
            self?._editedCards.value = self!.editor.allCards
        }
    }

    // MARK: - UpdateDelegate
    func update(currentTime: TimeInterval) {
        levelContainer.level.value?.update(currentTime: currentTime)
    }

    // MARK: - FrameDelegate
    func frameScanner(_ scanner: ARController, didUpdate frame: CVPixelBuffer, withOrientation orientation: CGImagePropertyOrientation) {
        editor.newFrame(frame,
                        oriented: orientation,
                        frameWidth: Double(UIScreen.main.bounds.width),
                        frameHeight: Double(UIScreen.main.bounds.height))
    }
}

protocol ARContainerViewModeling: UpdateDelegate, FrameDelegate {

    var editedProgram: ImmutableObservableProperty<ProgramProtocol?> { get }
    var editedCards: ImmutableObservableProperty<[CardNodeProtocol]> { get }
    var arController: ARController { get }

    /// Start updating the level and card scanner.
    func start()

    /// Stop updating the level and card scanner.
    func stop()
}
