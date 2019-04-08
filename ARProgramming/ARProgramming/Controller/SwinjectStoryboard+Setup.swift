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
        defaultContainer.storyboardInitCompleted(ARContainerViewController.self) { container, controller in
            controller.programEditor = container.resolve(ProgramEditorProtocol.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelViewController.self) { container, controller in
            controller.audioController = container.resolve(AudioController.self)
        }
        
        defaultContainer.register(AudioController.self) { _ in AudioController() }
            .inObjectScope(.container)
        defaultContainer.addProgram()
        
        addLibrary()
        addCardDetail()
        
        //Response to:
        //https://github.com/Swinject/Swinject/issues/213
        Container.loggingFunction = nil
    }
    
    private class func addLibrary() {
        let cardCollectionId = "CardCollection"
        
        defaultContainer.register(UICollectionViewDelegateFlowLayout.self, name: cardCollectionId) { _ in
            CardCollectionFlowLayoutDelegate()
        }
        
        defaultContainer.storyboardInitCompleted(CardLibraryViewController.self) { container, controller in
            let dataSource = CardCollectionDataSource(
                viewModel: CardCollectionViewModel(
                    cardCollection: container.resolve(CardCollection.self)!,
                    configuration: GradeConfig()))
            
            controller.dataSource = dataSource
            controller.flowLayoutDelegate = container.resolve(UICollectionViewDelegateFlowLayout.self, name: cardCollectionId)
        }
    }
    
    private class func addCardDetail() {
        defaultContainer.storyboardInitCompleted(ExampleProgramViewController.self) { container, controller in
            controller.tableDataSource = ExampleProgramTableDataSource(deserializer: container.resolve(CardGraphDeserializerProtocol.self)!)
        }
    }
}
