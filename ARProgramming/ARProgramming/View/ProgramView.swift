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
    
    var editor: ProgramEditorProtocol? {
        didSet {
            clear()
            populateProgramView()
        }
    }
    
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
    
    private func populateProgramView() {
        guard let editor = editor else {
            return
        }
        
        //First add the main function to ensure it comes first
        addArrangedSubview(createFunctionView(withProgram: editor.main))
        
        //Then add the remaining functions, if any
        let programs = editor.allPrograms.filter {
            $0 !== editor.main
        }
        
        for program in programs {
            addArrangedSubview(createFunctionView(withProgram: program))
        }
    }
    
    private func createFunctionView(withProgram program: ProgramProtocol) -> FunctionView {
        let fv = FunctionView()
        fv.setContentHuggingPriority(.required, for: .vertical)
        fv.setContentCompressionResistancePriority(.required, for: .vertical)
        fv.backgroundColor = .clear
        
        fv.program = program
        
        return fv
    }
}
