//
//  LevelDataSource.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class LevelDataSource: NSObject, UICollectionViewDataSource {
    
    private var levelsForGrade = [Int: [LevelViewModel]]()
    private let grade: Int
    
    init(grade: Int) {
        self.grade = grade
        levelsForGrade[grade] = []
        
        let levelGradeConfig = Config.read(configFile: "LevelClasses", toType: LevelGradeConfig.self)!
        let levelsForGrades = levelGradeConfig.levels
        
        for levelName in levelsForGrades[grade-1]{
            if let level = try? LevelManager.loadLevel(byName: levelName) {
                levelsForGrade[grade]?.append(LevelViewModel(level: level))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfLevels = levelsForGrade[grade]?.count {
            return numberOfLevels
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath)
        
        if let levelCell = cell as? LevelCollectionViewCell {
            let levelModel = levelsForGrade[grade]?[indexPath.item].levelModel
            if (indexPath.item == 0) {
                if let level = levelModel{
                    LevelManager.markLevel(withNumber: level.levelNumber, asUnlocked: true)
                    levelCell.unlocked = true
                }
            } else {
                levelCell.unlocked = levelModel?.unlocked
            }
            levelCell.level = levelModel
            levelCell.levelName.text = levelModel?.name
            if let levelTypeString = levelModel?.levelType {
                levelCell.levelType.text = NSLocalizedString("levelType.\(levelTypeString)", comment: "")
            }
        }
        return cell
    }
}

private struct LevelGradeConfig: Decodable {
    let levels: [[String]]
}
