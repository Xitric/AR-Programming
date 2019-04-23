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
    
    let running = ObservableProperty<Bool>(false)
    let activeCard = ObservableProperty<CardNodeProtocol?>()
    let main: ObservableProperty<ProgramProtocol?>
    let programs: ObservableProperty<[ProgramProtocol]>
    let executedCards = ObservableProperty<Int>(0)
    
    private var editor: ProgramEditorProtocol
    
    init(editor: ProgramEditorProtocol) {
        self.editor = editor
        
        main = ObservableProperty(editor.main)
        programs = ObservableProperty(editor.allPrograms)
    }
    
    func start(on entity: Entity) {
        editor.main.delegate = self
        editor.main.run(on: entity)
    }
    
    func reset() {
        editor.main.delegate = nil
        editor.reset()
        main.value = editor.main
        programs.value = editor.allPrograms
    }
    
    func add(program: ProgramProtocol) {
        editor.save(program)
        main.value = editor.main
        programs.value = editor.allPrograms
    }
    
    //MARK: - ProgramDelegate
    func programBegan(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.executedCards.value = 0
            self?.running.value = true
        }
    }
    
    func program(_ program: ProgramProtocol, willExecute cardNode: CardNodeProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.executedCards.value += 1
            self?.activeCard.value = cardNode
        }
    }
    
    func program(_ program: ProgramProtocol, executed cardNode: CardNodeProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.activeCard.value = nil
        }
    }
    
    func programEnded(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.running.value = false
        }
    }
}

protocol ProgramsViewModeling {
    
    var running: ObservableProperty<Bool> { get }
    var activeCard: ObservableProperty<CardNodeProtocol?> { get }
    var main: ObservableProperty<ProgramProtocol?> { get }
    var programs: ObservableProperty<[ProgramProtocol]> { get }
    var executedCards: ObservableProperty<Int> { get }
    
    func start(on entity: Entity)
    func reset()
    func add(program: ProgramProtocol)
}
