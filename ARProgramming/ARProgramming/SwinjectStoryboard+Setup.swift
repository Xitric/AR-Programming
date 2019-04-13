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
import Level

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.storyboardInitCompleted(WardrobeViewController.self) { container, controller in
            controller.wardrobe = container.resolve(WardrobeProtocol.self)
        }
        
        defaultContainer.register(AudioController.self) { _ in AudioController() }
            .inObjectScope(.container)
        
        defaultContainer.register(WardrobeProtocol.self) { _ in
            WardrobeManager(context: CoreDataRepository())
        }
        
        defaultContainer.addProgram()
        defaultContainer.addLevel()
        
        addLibrary()
        addCardDetail()
        addLevel()
        
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
            controller.levelRepository = container.resolve(LevelRepository.self)
            controller.previewLevelViewModel = container.resolve(LevelViewModel.self)
            controller.gameLevelViewModel = container.resolve(LevelViewModel.self)
        }
    }
    
    private class func addLevel() {
        defaultContainer.register(ARController.self) { _ in ARController() }
            .inObjectScope(.container)
        
        defaultContainer.register(LevelViewModel.self) { container in
            LevelViewModel(wardrobe: container.resolve(WardrobeProtocol.self)!)
        }.inObjectScope(.transient)
        
        defaultContainer.register(PlaneViewModel.self) { container in
            let pvm = PlaneViewModel()
            container.resolve(ARController.self)!.planeDetectorDelegate = pvm
            return pvm
        }
        
        defaultContainer.storyboardInitCompleted(LevelSelectViewController.self) { container, controller in
            let dataSource = LevelDataSource(levelRepository: container.resolve(LevelRepository.self)!)
            controller.dataSource = dataSource
            controller.levelRepository = container.resolve(LevelRepository.self)
            controller.levelViewModel = container.resolve(LevelViewModel.self)
        }
        
        let programEditor = defaultContainer.resolve(ProgramEditorProtocol.self)
        
        defaultContainer.storyboardInitCompleted(ARContainerViewController.self) { container, controller in
            controller.programEditor = programEditor
            controller.arController = container.resolve(ARController.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelViewController.self) { container, controller in
            controller.audioController = container.resolve(AudioController.self)
            controller.planeViewModel = container.resolve(PlaneViewModel.self)
            controller.programEditor = programEditor
        }
    }
}
