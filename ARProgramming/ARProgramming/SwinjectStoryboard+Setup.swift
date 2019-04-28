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
                    configuration: CardConfig()))
            
            controller.dataSource = dataSource
            controller.flowLayoutDelegate = container.resolve(UICollectionViewDelegateFlowLayout.self, name: cardCollectionId)
        }
    }
    
    private class func addCardDetail() {
        defaultContainer.register(ExampleProgramViewModeling.self) { container in
            ExampleProgramViewModel(levelRepository: container.resolve(LevelRepository.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ExampleProgramViewController.self) { container, controller in
            controller.tableDataSource = ExampleProgramTableDataSource(deserializer: container.resolve(CardGraphDeserializerProtocol.self)!)
            controller.viewModel = container.resolve(ExampleProgramViewModeling.self)
        }
        
        defaultContainer.storyboardInitCompleted(ExamplePreviewViewController.self) { container, controller in
            controller.viewModel = container.resolve(ExampleProgramViewModeling.self)
            controller.levelViewModel = container.resolve(LevelSceneViewModeling.self)
        }
    }
    
    private class func addLevel() {
        defaultContainer.register(ARController.self) { container in ARController() }.inObjectScope(.weak)
        
        defaultContainer.register(SurfaceDetectionViewModeling.self) { container in
            let pvm = SurfaceDetectionViewModel()
            container.resolve(ARController.self)!.planeDetectorDelegate = pvm
            return pvm
        }
        
        defaultContainer.register(LevelSceneViewModeling.self) { container in
            LevelSceneViewModel(wardrobe: container.resolve(WardrobeProtocol.self)!)
        }
        
        let programEditor = defaultContainer.resolve(ProgramEditorProtocol.self)!
        
        defaultContainer.register(ARContainerViewModeling.self) { container in
            ARContainerViewModel(editor: programEditor,
                                 arController: container.resolve(ARController.self)!)
        }
        
        defaultContainer.register(GameCoordinationViewModeling.self) { container in
            GameCoordinationViewModel(levelConfig: LevelConfig())
        }
        
        defaultContainer.register(LevelSelectViewModeling.self) { controller in
            LevelSelectViewModel(levelRepository: controller.resolve(LevelRepository.self)!)
        }
        
        defaultContainer.register(ProgramsViewModeling.self) { container in
            ProgramsViewModel(editor: programEditor)
        }
        
        defaultContainer.register(ScoreProtocol.self) { _ in
            ScoreManager(context: CoreDataRepository())
        }
        
        defaultContainer.register(LevelViewModeling.self) { container in
            LevelViewModel(levelRepository: container.resolve(LevelRepository.self)!,
                           scoreManager: container.resolve(ScoreProtocol.self)!)
        }
        
        defaultContainer.register(ExerciseCompletionViewModeling.self) { container in
            ExerciseCompletionViewModel(repository: container.resolve(LevelRepository.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(BranchLevelSelectViewController.self) { container, controller in
            controller.viewModel = container.resolve(LevelSelectViewModeling.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelSelectViewController.self) { container, controller in
            let dataSource = LevelDataSource(
                levelRepository: container.resolve(LevelRepository.self)!,
                scoreManager: container.resolve(ScoreProtocol.self)!,
                configuration: LevelConfig())
            controller.dataSource = dataSource
            controller.viewModel = container.resolve(LevelSelectViewModeling.self)
        }
        
        defaultContainer.storyboardInitCompleted(ARContainerViewController.self) { container, controller in
            controller.viewModel = container.resolve(ARContainerViewModeling.self)
            controller.dragDelegate = ProgramDragInteractionDelegate(serializer: container.resolve(CardGraphDeserializerProtocol.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(GameCoordinationViewController.self) { container, controller in
            let storyboard = UIStoryboard(name: "Exercise", bundle: Bundle.main)
            let surfaceController = storyboard.instantiateViewController(withIdentifier: "SurfaceDetectionScene")
            let onboardController = storyboard.instantiateViewController(withIdentifier: "CardDragScene")
            let levelController = storyboard.instantiateViewController(withIdentifier: "LevelScene")
            let cardController = storyboard.instantiateViewController(withIdentifier: "CardDescriptionScene")
            
            controller.viewModel = container.resolve(GameCoordinationViewModeling.self)
            controller.surfaceViewController = surfaceController
            controller.onboardingViewController = onboardController
            controller.levelViewController = levelController
            controller.cardViewController = cardController
            
            (surfaceController as? SurfaceDetectionViewController)?.delegate = controller
            (onboardController as? CardDragOnboardingViewController)?.delegate = controller
            (cardController as? CardDescriptionViewController)?.delegate = controller
        }
        
        defaultContainer.storyboardInitCompleted(SurfaceDetectionViewController.self) { container, controller in
            controller.viewModel = container.resolve(SurfaceDetectionViewModeling.self)
            controller.levelViewModel = container.resolve(LevelSceneViewModeling.self)
        }
        
        defaultContainer.storyboardInitCompleted(LevelViewController.self) { container, controller in
            controller.audioController = container.resolve(AudioController.self)
            controller.viewModel = container.resolve(LevelViewModeling.self)
            controller.programsViewModel = container.resolve(ProgramsViewModeling.self)
            controller.dropDelegate = ProgramDropInteractionDelegate(serializer: container.resolve(CardGraphDeserializerProtocol.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ExerciseCompletionViewController.self) { container, controller in
            controller.viewModel = container.resolve(ExerciseCompletionViewModeling.self)
        }
    }
}
