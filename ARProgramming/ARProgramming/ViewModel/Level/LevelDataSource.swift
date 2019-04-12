//
//  LevelDataSource.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import Level

class LevelDataSource: NSObject, UICollectionViewDataSource {
    
    private var levelsForGrade = [Int: [LevelProtocol]]()
    
    var grade: Int? {
        didSet {
            if let grade = grade {
                levelsForGrade[grade] = []
                let levelGradeConfig = Config.read(configFile: "LevelClasses", toType: LevelGradeConfig.self)!
                let levelsForGrades = levelGradeConfig.levels
                for levelName in levelsForGrades[grade-1]{
                    if let level = try? levelRepository.loadLevel(byName: levelName) {
                        levelsForGrade[grade]?.append(level)
                    }
                }
            }
        }
    }
    var scoreManager: ScoreProtocol!
    var levelRepository: LevelRepository!
    
    init(levelRepository: LevelRepository, scoreManager: ScoreProtocol) {
        self.levelRepository = levelRepository
        self.scoreManager = scoreManager
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let grade = grade, let numberOfLevels = levelsForGrade[grade]?.count {
            return numberOfLevels
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath)
        
        if let grade = grade, let levelCell = cell as? LevelCollectionViewCell {
            let level = levelsForGrade[grade]?[indexPath.item]
            if (indexPath.item == 0) {
                if let level = level{
                    levelRepository.markLevel(withNumber: level.levelNumber, asUnlocked: true, completion: nil)
                    levelCell.unlocked = true
                }
            } else {
                levelCell.unlocked = level?.unlocked
            }
            levelCell.score.text = score(levelNumber: level)
            levelCell.level = level
            levelCell.levelName.text = level?.name
            if let levelTypeString = level?.levelType {
                levelCell.levelType.text = NSLocalizedString("levelType.\(levelTypeString)", comment: "")
            }
        }
        return cell
    }
    
    private func score(levelNumber: LevelProtocol?) -> String{
        var score = "☆☆☆"
        if let level = levelNumber {
            let scoreCount = scoreManager.getScore(forLevel: level.levelNumber)
            if scoreCount > 0 {
                score = String(repeating: "⭐", count: scoreCount)
                let blackStars = String(repeating: "☆", count: 3-scoreCount)
                score.append(blackStars)
            }
            print(score)
        }
        return score
    }
}

private struct LevelGradeConfig: Decodable {
    let levels: [[String]]
}
