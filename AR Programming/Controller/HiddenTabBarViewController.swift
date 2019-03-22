//
//  HiddenTabBarViewController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class HiddenTabBarViewController: UITabBarController {
    
    private var levelViewModel: LevelViewModel?
    private var arController: ARController?
    private var programEditor: ProgramEditor? {
        didSet {
            programEditor?.delegate = self
        }
    }
    private var cardRects = [CardRect]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.isHidden = true
        
        goToViewControllerWith(index: 0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    

    func goToViewControllerWith(index: Int) {
        if let gameplayController = selectedViewController as? GameplayController {
            gameplayController.exit(withLevel: levelViewModel, inEnvironment: arController, withEditor: programEditor)
        }
        
        self.selectedIndex = index
        
        if let gameplayController = selectedViewController as? GameplayController {
            gameplayController.enter(withLevel: levelViewModel, inEnvironment: arController, withEditor: programEditor)
        }
    }
}

// MARK: - GamePlayController
extension HiddenTabBarViewController: GameplayController {
    func enter(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?, withEditor programEditor: ProgramEditor?) {
        self.levelViewModel = levelViewModel
        self.arController = arController
        self.programEditor = programEditor
    }
    
    func exit(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?, withEditor programEditor: ProgramEditor?) {
        self.levelViewModel = nil
        self.arController = nil
        self.programEditor = nil
    }
}

// MARK: - ProgramEditorDelegate
extension HiddenTabBarViewController: ProgramEditorDelegate {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program) {
        for case let rect as CardRect in view.subviews {
            cardRects.append(rect)
            rect.removeFromSuperview()
        }
        drawNode(program.start)
    }
    
    private func drawNode(_ node: CardNode?) {
        guard let node = node else {
            return
        }
        //print(cardRects.count)
        if let rect = cardRects.popLast() {
            rect.frame = CGRect(x: node.position.x - 48, y: Double(UIScreen.main.bounds.height) - node.position.y - 48, width: 96, height: 96)
            view.addSubview(rect)
        } else {
            let cardRect = CardRect(frame:  CGRect(x: node.position.x - 48, y: Double(UIScreen.main.bounds.height) - node.position.y - 48, width: 96, height: 96), card: node.getCard(), viewController: self)
            view.addSubview(cardRect)
        }
        for next in node.successors {
            drawNode(next)
        }
    }
}

// MARK: UICardRectDelegate
extension HiddenTabBarViewController: UICardRectDelegate {
    func cardRect(_ cardRect: CardRect, didPressCard card: Card?) {
        
            self.goToViewControllerWith(index: 1)

//        (self.tabBarController?.selectedViewController as? ScanViewController)?.display(card: card)
//        print(self.tabBarController?.selectedViewController as? ScanViewController)
////
////                if let scanViewController = self.tabBarController?.viewControllers?[1] as? ScanViewController {
////                    scanViewController.display(card: LeftCard())
////                    print("HiddenTabBarViewController cardRect caleld")
////                }
    }
}

extension HiddenTabBarViewController: UITabBarControllerDelegate {
//    func didChangeValue<Value>(for keyPath: KeyPath<HiddenTabBarViewController, Value>) {
//        print("changed value")
//        self.tabBarController?.selectedViewController as? ScanViewController
//    }

}
