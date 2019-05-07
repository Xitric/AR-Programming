//
//  LevelSceneViewModelTests.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Level
import EntityComponentSystem
@testable import ARProgramming
import Foundation

class LevelSceneViewModelTests: XCTestCase {
    
    private var levelContainer: CurrentLevelProtocol!
    private var wardrobe: WardrobeProtocol!
    private var level: LevelProtocol!
    private var levelSceneViewModel: LevelSceneViewModeling!
    
    override func setUp() {
        level = LevelMock()
        levelContainer = CurrentLevelMock(levelMock: level)
        wardrobe = WardrobeMock()
        levelSceneViewModel = LevelSceneViewModel(level: levelContainer, wardrobe: wardrobe)
    }
    
    func testAnchor(){
        // Arrange
        let sceneNode1 = SCNNode()
        let sceneNode2 = SCNNode()
       
        // Act
        levelSceneViewModel.anchor(at: sceneNode1)
        level.entityManager.update(delta: 1)
        
        // Assert
        XCTAssertEqual(sceneNode1.childNodes.count, 1)
        
        // Act
        levelSceneViewModel.anchor(at: sceneNode1)
        level.entityManager.update(delta: 1)
        
        // Assert
        XCTAssertEqual(sceneNode1.childNodes.count, 1)
        
        // Act
        levelSceneViewModel.anchor(at: nil)
        level.entityManager.update(delta: 1)
        
        // Assert
        XCTAssertEqual(sceneNode1.childNodes.count, 0)
        
        // Act
        levelSceneViewModel.anchor(at: sceneNode2)
        level.entityManager.update(delta: 1)
        
        // Assert
        XCTAssertEqual(sceneNode1.childNodes.count, 0)
        XCTAssertEqual(sceneNode2.childNodes.count, 1)
    }
    
    func testAddNode(){
        // Arrange
        let sceneNode1 = SCNNode()
        let sceneNode2 = SCNNode()
        let sceneNode3 = SCNNode()
        
        // Assume
        XCTAssertNil(sceneNode1.parent)
        XCTAssertNil(sceneNode2.parent)
        XCTAssertNil(sceneNode3.parent)
        
        // Act
        levelSceneViewModel.addNode(sceneNode1)
        levelSceneViewModel.addNode(sceneNode2)
        levelSceneViewModel.addNode(sceneNode3)
        
        // Assert
        XCTAssertNotNil(sceneNode1.parent)
        XCTAssertNotNil(sceneNode2.parent)
        XCTAssertNotNil(sceneNode3.parent)
        XCTAssertEqual(sceneNode3.parent?.childNodes.count, 4) // Player
    }
    
    private class CurrentLevelMock: CurrentLevelProtocol {
        
        var level: ObservableProperty<LevelProtocol?>
        
        init(levelMock: LevelProtocol) {
            level = ObservableProperty<LevelProtocol?>()
            self.level.value = levelMock
        }
    }
    
    private class WardrobeMock: WardrobeProtocol {
        
        func selectedRobotSkin() -> String {
            return ""
        }
        
        func getFileNames() -> [String] {
            return [""]
        }
        
        func setRobotChoice(choice: String, callback: (() -> Void)?) {
            
        }
    }
    
    private class LevelMock: LevelProtocol {
        
        var name: String
        var levelNumber: Int
        var levelType: String
        var unlocked: Bool
        var unlocks: Int?
        var infoLabel: String?
        var entityManager: EntityManager
        var delegate: LevelDelegate?
        
        init() {
            self.name = "TestLevel"
            self.levelNumber = 1000
            self.levelType = "TestType"
            self.unlocked = true
            self.entityManager = EntityManager()
        }
        
        func update(currentTime: TimeInterval) {
    
        }
        
        func isComplete() -> Bool {
            return false
        }
    }
}
