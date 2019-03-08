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
    
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = self
            levelSelectCollectionView.delegate = self
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
    
    //Ignore this code, it only exists for development purposes
    @IBAction func recreateLevels(_ sender: Any) {
        let l1 = QuantityLevel(type: "quantity", name: "Level 1", number: 1, unlocks: "Level 2")
        try? LevelManager.saveLevel(l1)
        
        let l2 = QuantityLevel(type: "quantity", name: "Level 2", number: 2, unlocks: "Level 3")
        try? LevelManager.saveLevel(l2)
        
        let l3 = QuantityLevel(type: "quantity", name: "Level 3", number: 3, unlocks: nil)
        try? LevelManager.saveLevel(l3)
        
        // Call levelManager to save unlocked levels in Core Data
        LevelManager.markLevel(withName: l1.name, asUnlocked: true) { [unowned self] in
            //Reload view
            self.levels.removeAll()
            if let allLevels = try? LevelManager.loadAllLevels() {
                self.levels.append(contentsOf: allLevels)
            }
            self.levelSelectCollectionView.reloadData()
        }
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
