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
    
    //MARK: - Observers
    private var programsObserver: Observer?
    private var cardSizeObserver: Observer?
    
    //MARK: - Injected properties
    var viewModel: ProgramsViewModeling! {
        didSet {
            programsObserver = viewModel.programs.observe { [weak self] programs in
                self?.populateProgramView(with: programs)
            }
            
            cardSizeObserver = viewModel.cardSize.observe { [weak self] size in
                self?.scale = size == nil ? nil : CGFloat(size!)
            }
        }
    }
    private var scale: CGFloat? {
        didSet {
            if (scale != oldValue) {
                self.populateProgramView(with: viewModel.programs.value)
            }
        }
    }
    
    //MARK: - Life cycle
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
    
    deinit {
        programsObserver?.release()
        cardSizeObserver?.release()
    }
    
    //MARK: - Functionality
    private func clear() {
        for subView in arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    private func populateProgramView(with programs: [ProgramProtocol]) {
        clear()
        
        //First add the main function to ensure it comes first
        if let main = viewModel.main.value {
            addArrangedSubview(createFunctionView(withProgram: main))
        }
        
        //Then add the remaining functions, if any
        let filteredPrograms = programs.filter {
            $0 !== viewModel.main.value
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
}
