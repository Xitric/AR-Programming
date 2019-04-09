//
//  LevelSelectViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, GradeViewController {
    var grade: Int!

    var selectedLevel: Level?
    
    private lazy var dataSource: LevelDataSource = {
        let source = LevelDataSource(grade: grade)
        return source
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = dataSource
            levelSelectCollectionView.delegate = self
        }
    }
    @IBOutlet weak var freePlayView: UIView! {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = freePlayView.bounds
            gradientLayer.colors = [
                UIColor.white.withAlphaComponent(0).cgColor,
                UIColor.white.withAlphaComponent(1).cgColor
            ]
            self.freePlayView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            arContainer.level = selectedLevel
        }

    }
    
    @IBAction func freePlay(_ sender: UIButton) {
        selectedLevel = LevelManager.emptylevel
        performSegue(withIdentifier: "arContainerSegue", sender: self)
    }
    
}

// MARK: - UICollectionViewDelegate
extension LevelSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let level  = collectionView.cellForItem(at: indexPath) as? LevelCollectionViewCell {
            selectedLevel = level.level
        }
        performSegue(withIdentifier: "arContainerSegue", sender: self)
    }
}
