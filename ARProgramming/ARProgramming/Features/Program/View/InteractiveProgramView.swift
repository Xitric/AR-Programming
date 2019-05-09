//
//  InteractiveProgramView.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import ProgramModel

class InteractiveProgramView: ProgramView {

    weak var delegate: InteractiveProgramDelegate?

    // MARK: - Observers
    private var activeCardObserver: Observer?

    // MARK: - Injected properties
    override var viewModel: ProgramsViewModeling! {
        get {
            return super.viewModel
        }
        set {
            super.viewModel = newValue
            activeCardObserver = viewModel.activeCard.observeFuture { [weak self] cardNode in
                self?.highlight(cardNode: cardNode)
            }
        }
    }

    deinit {
        activeCardObserver?.release()
    }

    private func highlight(cardNode: CardNodeProtocol?) {
        for subview in self.arrangedSubviews {
            if let functionView = subview as? FunctionView {
                functionView.highlightNode = cardNode
            }
        }
    }

    override func createFunctionView(withProgram program: ProgramProtocol) -> FunctionView {
        let fv = super.createFunctionView(withProgram: program)
        fv.addGestureRecognizer(FunctionTapGestureRecognizer(target: self,
                                                             action: #selector(onFunctionViewTapped(_:)),
                                                             program: program))
        return fv
    }

    @objc private func onFunctionViewTapped(_ sender: FunctionTapGestureRecognizer) {
        delegate?.interactiveProgram(self, pressed: sender.program)
    }
}

protocol InteractiveProgramDelegate: class {

    func interactiveProgram(_ view: InteractiveProgramView, pressed program: ProgramProtocol)
}

private class FunctionTapGestureRecognizer: UITapGestureRecognizer {

    let program: ProgramProtocol

    init(target: Any?, action: Selector?, program: ProgramProtocol) {
        self.program = program
        super.init(target: target, action: action)
    }
}
