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
            controller.programEditor = container.resolve(ProgramEditor.self)
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
        defaultContainer.register(GradeCardConfiguration.self) { _ in GradeConfig() }
        
        defaultContainer.register(CardCollectionViewModel.self) { container in
            return CardCollectionViewModel(
                cardCollection: container.resolve(CardCollection.self)!,
                configuration: container.resolve(GradeCardConfiguration.self)!)
        }
        
        let cardCollectionId = "CardCollection"
        
        defaultContainer.register(CardCollectionDataSource.self, name: cardCollectionId) { container in
            CardCollectionDataSource(viewModel: container.resolve(CardCollectionViewModel.self)!)
        }
        
        defaultContainer.register(UICollectionViewDelegateFlowLayout.self, name: cardCollectionId) { _ in
            CardCollectionFlowLayoutDelegate()
        }
        
        defaultContainer.storyboardInitCompleted(CardLibraryViewController.self) { container, controller in
            controller.dataSource = container.resolve(CardCollectionDataSource.self, name: cardCollectionId)
            controller.flowLayoutDelegate = container.resolve(UICollectionViewDelegateFlowLayout.self, name: cardCollectionId)
        }
    }
    
    private class func addCardDetail() {
        defaultContainer.register(ExampleProgramTableDataSource.self) { container in
            ExampleProgramTableDataSource(deserializer: container.resolve(CardGraphDeserializer.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(ExampleProgramViewController.self) { container, controller in
            controller.tableDataSource = container.resolve(ExampleProgramTableDataSource.self)
        }
    }
}
