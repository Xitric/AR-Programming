//
//  LevelSelectViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {
    
    private var levels = [Level]()
    var selectedLevel: Level?
    
    @IBOutlet weak var freePlayButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = self
            levelSelectCollectionView.delegate = self
        }
    }
    @IBOutlet weak var freePlayView: UIView! {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = freePlayView.bounds
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
            self.freePlayView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: Error dialog?
        if let allLevels = try? LevelManager.loadAllLevels() {
            levels.append(contentsOf: allLevels)
        }
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

// MARK: - UICollectionViewDataSource
extension LevelSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath)
        
        if let levelCell = cell as? LevelCollectionViewCell {
            let level = levels[indexPath.item]
            levelCell.levelName.text = level.name
            levelCell.unlocked = level.unlocked
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LevelSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLevel = levels[indexPath.item]
        performSegue(withIdentifier: "arContainerSegue", sender: self)
    }
}
