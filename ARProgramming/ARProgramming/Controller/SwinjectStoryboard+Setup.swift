//
//  SwinjectStoryboard+Setup.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import ProgramModel

extension SwinjectStoryboard {
    class func setup() {
        //ARContainerViewController
        defaultContainer.storyboardInitCompleted(ARContainerViewController.self) { container, controller in
            controller.programEditor = container.resolve(ProgramEditor.self)
        }
        
        //LevelViewController
        defaultContainer.storyboardInitCompleted(LevelViewController.self) { container, controller in
            controller.audioController = container.resolve(AudioController.self)
        }
        
        //CardLibraryViewController
        defaultContainer.storyboardInitCompleted(CardLibraryViewController.self) { container, controller in
            controller.cards = container.resolve(CardCollection.self)
        }
        
        //ExampleProgramViewController
        defaultContainer.storyboardInitCompleted(ExampleProgramViewController.self) { container, controller in
            controller.deserializer = container.resolve(CardGraphDeserializer.self)
        }
        
        defaultContainer.register(AudioController.self) { _ in AudioController() }
            .inObjectScope(.container)
        defaultContainer.addProgram()
        
        //Response to:
        //https://github.com/Swinject/Swinject/issues/213
        Container.loggingFunction = nil
    }
}
