//
//  ProgramEditorProtocol.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 08/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// An editor is used to analyze raw images for card sequences and storing all currently identified functions.
///
/// An editor can be compared to a highly simplistic IDE used for developing software.
public protocol ProgramEditorProtocol {
    var delegate: ProgramEditorDelegate? { get set }

    /// The main program created by this editor. This is usually the first program that should be executed.
    var main: ProgramProtocol { get }

    /// All programs created by this editor. This contains both the main program and any functions.
    var allPrograms: [ProgramProtocol] { get }

    /// A collection of all cards that are currently being used inside this editor.
    ///
    /// This contains all cards that are visible to the application. Some of these cards may be part of a program, while others may not.
    var allCards: [CardNodeProtocol] { get }

    /// Saves the specified program in the memory of this editor.
    ///
    /// This will overwrite any existing program, if any, that shares the same function id as the program being saved. The function id of a program is represented by the first card in the sequence. This can be a start card or a function card.
    ///
    /// - Parameter program: The program to save.
    func save(_ program: ProgramProtocol)

    /// Clears the memory of this editor, deleting all currently stored programs.
    func reset()

    /// Notify this editor of a new image for analysis.
    ///
    /// This method should only ever be called from the main thread of the application. It will execute asynchronously and thus return almost immideately. The editor will notify its delegate whenever the image analysis has resulted in knowledge of a new program.
    ///
    /// - Parameters:
    ///   - frame: The image to analyze for cards.
    ///   - orientation: The orientation of the image.
    ///   - frameWidth: The width of the image, in pixels.
    ///   - frameHeight: The height of the image, in pixels.
    func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double)
}

/// An object that can receive callbacks from a ProgramEditor whenever a new program has been detected as a result of image analysis.
public protocol ProgramEditorDelegate: class {
    func programEditor(_ programEditor: ProgramEditorProtocol, createdNew program: ProgramProtocol)
}
