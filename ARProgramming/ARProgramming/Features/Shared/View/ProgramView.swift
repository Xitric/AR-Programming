//
//  ProgramView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 01/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import ProgramModel

class ProgramView: UIStackView {
    
    var programsViewModel: ProgramsViewModeling! {
        didSet {
            clear()
            programsViewModel.programs.onValue = { [weak self] programs in
                self?.clear()
                self?.populateProgramView(with: programs)
            }
            
            populateProgramView(with: programsViewModel.programs.value)
            
            programsViewModel.activeCard.onValue = { [weak self] cardNode in
                self?.highlight(cardNode: cardNode)
            }
        }
    }
    var scale: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fillProportionally
        self.spacing = 24
    }
    
    private func clear() {
        for subView in arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    private func populateProgramView(with programs: [ProgramProtocol]) {
        
        //First add the main function to ensure it comes first
        if let main = programsViewModel.main.value {
            addArrangedSubview(createFunctionView(withProgram: main))
        }
        
        //Then add the remaining functions, if any
        let filteredPrograms = programs.filter {
            $0 !== programsViewModel.main.value
        }
        
        for program in filteredPrograms {
            addArrangedSubview(createFunctionView(withProgram: program))
        }
    }
    
    private func createFunctionView(withProgram program: ProgramProtocol) -> FunctionView {
        let fv = FunctionView()
        fv.setContentHuggingPriority(.required, for: .vertical)
        fv.setContentCompressionResistancePriority(.required, for: .vertical)
        fv.backgroundColor = .clear
        
        if let scale = scale {
            fv.scale = scale
        }
        fv.program = program
        
        return fv
    }
    
    private func highlight(cardNode: CardNodeProtocol?) {
        for subview in self.arrangedSubviews {
            if let functionView = subview as? FunctionView {
                functionView.highlightNode = cardNode
            }
        }
    }
}
