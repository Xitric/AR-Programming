//
//  LevelSelectViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import Level

class LevelSelectViewController: UIViewController, GradeViewController {

    var grade: Int! {
        didSet {
            self.dataSource.grade = grade
        }
    }
    var selectedLevel: LevelProtocol?
    var levelRepository: LevelRepository!
    var dataSource: LevelDataSource!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = dataSource
            levelSelectCollectionView.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            arContainer.level = selectedLevel
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension LevelSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let level  = collectionView.cellForItem(at: indexPath) as? LevelCollectionViewCell {
            selectedLevel = level.level
            performSegue(withIdentifier: "arContainerSegue", sender: self)
        }
    }
}
