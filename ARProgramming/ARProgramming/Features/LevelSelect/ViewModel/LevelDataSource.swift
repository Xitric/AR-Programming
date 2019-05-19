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

    private var levelPreviews: [LevelInfoProtocol]?
    private let levelRepository: LevelRepository
    private let scoreManager: ScoreProtocol
    private let configuration: GradeLevelConfiguration

    var grade: Int?

    init(levelRepository: LevelRepository, scoreManager: ScoreProtocol, configuration: GradeLevelConfiguration) {
        self.levelRepository = levelRepository
        self.scoreManager = scoreManager
        self.configuration = configuration
    }

    func reloadData(completion: @escaping () -> Void) {
        if let grade = grade {
            levelRepository.loadPreviews(forLevels: configuration.levels(forGrade: grade)) { [weak self] previews, _ in
                DispatchQueue.main.async {
                    if let previews = previews {
                        self?.levelPreviews = previews
                    }

                    completion()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelPreviews?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath)

        if let levelCell = cell as? LevelCollectionViewCell {
            let level = levelPreviews?[indexPath.item]
            levelCell.unlocked = level?.unlocked
            levelCell.score.text = score(levelNumber: level!.levelNumber)
            levelCell.levelNumber = level?.levelNumber
            levelCell.levelName.text = level?.name
            if let levelTypeString = level?.levelType {
                levelCell.levelType.text = NSLocalizedString("levelType.\(levelTypeString)", comment: "")
            }
        }
        return cell
    }

    private func score(levelNumber: Int) -> String {
        var score = "☆☆☆"
        let scoreCount = scoreManager.getScore(forLevel: levelNumber)
        if scoreCount > 0 {
            score = String(repeating: "⭐", count: scoreCount)
            let blackStars = String(repeating: "☆", count: 3-scoreCount)
            score.append(blackStars)
        }
        return score
    }
}
