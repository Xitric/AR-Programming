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
            controller.wardrobe = container.resolve(WardrobeProtocol.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelViewController.self) { container, controller in
            controller.audioController = container.resolve(AudioController.self)
        }
        
        defaultContainer.storyboardInitCompleted(WardrobeViewController.self) { container, controller in
            controller.wardrobe = container.resolve(WardrobeProtocol.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelSelectViewController.self) { container, controller in
            controller.levelManager = container.resolve(LevelManager.self)
        }
        
        defaultContainer.register(AudioController.self) { _ in AudioController() }
            .inObjectScope(.container)
        defaultContainer.addProgram()
        
        defaultContainer.register(CoreDataRepository.self) { _ in CoreDataRepository() }
        
        defaultContainer.register(WardrobeProtocol.self) { container in
            WardrobeManager(context: container.resolve(CoreDataRepository.self)!)
        }
        
        defaultContainer.register(LevelManager.self) { container in
            LevelManager(context: container.resolve(CoreDataRepository.self)!)
        }
        
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
            controller.wardrobe = container.resolve(WardrobeProtocol.self)
            controller.levelManager = container.resolve(LevelManager.self)
        }
        
        defaultContainer.storyboardInitCompleted(CardDetailViewController.self) { container, controller in
            controller.levelManager = container.resolve(LevelManager.self)
        }
    }
}
