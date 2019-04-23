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
            controller.previewLevelViewModel = container.resolve(LevelViewModeling.self)
            controller.gameLevelViewModel = container.resolve(LevelViewModeling.self)
        }
    }
    
    private class func addLevel() {
        defaultContainer.register(ARController.self) { container in ARController() }.inObjectScope(.container)
        
        defaultContainer.register(LevelViewModeling.self) { container in
            LevelViewModel(wardrobe: container.resolve(WardrobeProtocol.self)!,
                           levelRepository: container.resolve(LevelRepository.self)!)
        }.inObjectScope(.transient)
        
        defaultContainer.register(PlaneViewModel.self) { container in
            let pvm = PlaneViewModel()
            container.resolve(ARController.self)!.planeDetectorDelegate = pvm
            return pvm
        }
        
        let programEditor = defaultContainer.resolve(ProgramEditorProtocol.self)!
        
        defaultContainer.register(ProgramEditorViewModeling.self) { container in
            let viewModel = ProgramEditorViewModel(editor: programEditor)
            container.resolve(ARController.self)?.frameDelegate = viewModel
            return viewModel
        }
        
        defaultContainer.register(ProgramsViewModeling.self) { container in
            ProgramsViewModel(editor: programEditor)
        }
        
        defaultContainer.register(ScoreProtocol.self) { _ in
            ScoreManager(context: CoreDataRepository())
        }
        
        defaultContainer.storyboardInitCompleted(BranchLevelSelectViewController.self) { container, controller in
            controller.levelRepository = container.resolve(LevelRepository.self)
            controller.levelViewModel = container.resolve(LevelViewModeling.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelSelectViewController.self) { container, controller in
            let dataSource = LevelDataSource(
                levelRepository: container.resolve(LevelRepository.self)!,
                scoreManager: container.resolve(ScoreProtocol.self)!)
            controller.dataSource = dataSource
            controller.levelRepository = container.resolve(LevelRepository.self)
            controller.levelViewModel = container.resolve(LevelViewModeling.self)
        }
        
        defaultContainer.storyboardInitCompleted(ARContainerViewController.self) { container, controller in
            controller.programEditorViewModel = container.resolve(ProgramEditorViewModeling.self)
            controller.arController = container.resolve(ARController.self)
            controller.dragDelegate = ProgramDragInteractionDelegate(serializer: container.resolve(CardGraphDeserializerProtocol.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(GameCoordinationViewController.self) { container, controller in
            let storyboard = UIStoryboard(name: "Exercise", bundle: Bundle.main)
            let surfaceController = storyboard.instantiateViewController(withIdentifier: "SurfaceDetectionScene")
            let levelController = storyboard.instantiateViewController(withIdentifier: "LevelScene")
            let cardController = storyboard.instantiateViewController(withIdentifier: "CardDescriptionScene")
            
            controller.surfaceViewController = surfaceController
            controller.levelViewController = levelController
            controller.cardViewController = cardController
            
            (surfaceController as? SurfaceDetectionViewController)?.delegate = controller
            (cardController as? CardDescriptionViewController)?.delegate = controller
        }
        
        defaultContainer.storyboardInitCompleted(SurfaceDetectionViewController.self) { container, controller in
            controller.planeViewModel = container.resolve(PlaneViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelViewController.self) { container, controller in
            controller.audioController = container.resolve(AudioController.self)
            controller.scoreManager = container.resolve(ScoreProtocol.self)
            controller.programsViewModel = container.resolve(ProgramsViewModeling.self)
            controller.dropDelegate = ProgramDropInteractionDelegate(serializer: container.resolve(CardGraphDeserializerProtocol.self)!)
        }
    }
}
