//
//  ProgramsViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 14/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ProgramModel
import EntityComponentSystem

class ProgramsViewModel: ProgramsViewModeling, ProgramDelegate {

    //We can mutate the properties internally, but only observe changes externally
    private let _running = ObservableProperty<Bool>(false)
    private let _activeCard = ObservableProperty<CardNodeProtocol?>()
    private let _main: ObservableProperty<ProgramProtocol?>
    private let _programs: ObservableProperty<[ProgramProtocol]>
    private let _executedCards = ObservableProperty<Int>(0)
    private let editor: ProgramEditorProtocol

    var running: ImmutableObservableProperty<Bool> {
        return _running
    }
    var activeCard: ImmutableObservableProperty<CardNodeProtocol?> {
        return _activeCard
    }
    var main: ImmutableObservableProperty<ProgramProtocol?> {
        return _main
    }
    var programs: ImmutableObservableProperty<[ProgramProtocol]> {
        return _programs
    }
    var executedCards: ImmutableObservableProperty<Int> {
        return _executedCards
    }
    var cardSize = ObservableProperty<Double?>()

    init(editor: ProgramEditorProtocol) {
        self.editor = editor

        _main = ObservableProperty(editor.main)
        _programs = ObservableProperty(editor.allPrograms)
    }

    func start(on entity: Entity) {
        editor.main.delegate = self
        editor.main.run(on: entity)
    }

    func reset() {
        editor.main.delegate = nil
        editor.reset()
        _running.value = false
        _activeCard.value = nil
        _main.value = editor.main
        _programs.value = editor.allPrograms
        _executedCards.value = 0
    }

    func add(program: ProgramProtocol) {
        editor.save(program)
        _main.value = editor.main
        _programs.value = editor.allPrograms
    }

    // MARK: - ProgramDelegate
    func programBegan(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?._executedCards.value = 0
            self?._running.value = true
        }
    }

    func program(_ program: ProgramProtocol, willExecute cardNode: CardNodeProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?._executedCards.value += 1
            self?._activeCard.value = cardNode
        }
    }

    func program(_ program: ProgramProtocol, executed cardNode: CardNodeProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?._activeCard.value = nil
        }
    }

    func programEnded(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?._running.value = false
        }
    }
}

protocol ProgramsViewModeling {

    var running: ImmutableObservableProperty<Bool> { get }
    var activeCard: ImmutableObservableProperty<CardNodeProtocol?> { get }
    var main: ImmutableObservableProperty<ProgramProtocol?> { get }
    var programs: ImmutableObservableProperty<[ProgramProtocol]> { get }
    var executedCards: ImmutableObservableProperty<Int> { get }
    var cardSize: ObservableProperty<Double?> { get }

    func start(on entity: Entity)
    func reset()
    func add(program: ProgramProtocol)
}
