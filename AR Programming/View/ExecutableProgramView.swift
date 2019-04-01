//
//  ExecutableProgramView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 01/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class ExecutableProgramView: UIView {
    
    @IBOutlet weak var functionStack: UIStackView!
    
    var editor: ProgramEditor? {
        didSet {
            if editor != nil {
                populateProgramView()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromXib()
    }
    
    private func setupFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        self.backgroundColor = .clear
    }
    
    func populateProgramView() {
        guard let editor = editor else {
            return
        }
        
        //First add the main program to ensure it comes first
        functionStack.addArrangedSubview(createProgramView(withProgram: editor.main))
        
        //Then add the functions, if any
        let programs = editor.allPrograms.filter {
            $0 !== editor.main
        }
        
        for program in programs {
            functionStack.addArrangedSubview(createProgramView(withProgram: program))
        }
    }
    
    private func createProgramView(withProgram program: Program) -> ProgramView {
        let pv = ProgramView()
        pv.setContentHuggingPriority(.required, for: .vertical)
        pv.setContentCompressionResistancePriority(.required, for: .vertical)
        pv.backgroundColor = .clear
        
        pv.program = program
        
        return pv
    }
}
