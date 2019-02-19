//
//  LevelSelectViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private var levels = [Level]()
    var selectedLevel: Level?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = self
            levelSelectCollectionView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        levels.removeAll()
        levels.append(contentsOf: LevelManager.loadAllLevels())
        collectionView.reloadData()
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLevel = levels[indexPath.item]
        performSegue(withIdentifier: "arContainerSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            arContainer.level = selectedLevel
        }
    }
    
    //Ignore this code, it only exists for development purposes
    @IBAction func recreateLevels(_ sender: Any) {
        let l1 = Level(name: "Level 1", number: 1, unlocks: "Level 2")
        l1.tiles = TileMap(width: 2, height: 1)
        l1.tiles.setCollectible(x: 1, y: 0)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 1.json") {
            try? l1.json?.write(to: url)
        }
        
        let l2 = Level(name: "Level 2", number: 2, unlocks: "Level 3")
        l2.tiles = TileMap(width: 1, height: 4)
        l2.tiles.setCollectible(x: 0, y: 2)
        l2.tiles.setCollectible(x: 0, y: 3)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 2.json") {
            try? l2.json?.write(to: url)
        }
        
        let l3 = Level(name: "Level 3", number: 3, unlocks: "Level 4")
        l3.tiles = TileMap(width: 3, height: 3)
        l3.tiles.setCollectible(x: 1, y: 0)
        l3.tiles.setCollectible(x: 2, y: 0)
        l3.tiles.setCollectible(x: 2, y: 1)
        l3.tiles.setCollectible(x: 2, y: 2)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 3.json") {
            try? l3.json?.write(to: url)
        }
        
        let l4 = Level(name: "Level 4", number: 4, unlocks: "Level 5")
        l4.tiles = TileMap(width: 4, height: 3)
        l4.tiles.setCollectible(x: 1, y: 0)
        l4.tiles.setCollectible(x: 2, y: 1)
        l4.tiles.setCollectible(x: 3, y: 2)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 4.json") {
            try? l4.json?.write(to: url)
        }
        
        let l5 = Level(name: "Level 5", number: 5, unlocks: "Level 6")
        l5.tiles = TileMap(width: 5, height: 5)
        l5.tiles.setCollectible(x: 0, y: 1)
        l5.tiles.setCollectible(x: 0, y: 2)
        l5.tiles.setCollectible(x: 0, y: 3)
        
        l5.tiles.setCollectible(x: 1, y: 0)
        l5.tiles.setCollectible(x: 2, y: 0)
        l5.tiles.setCollectible(x: 3, y: 0)
        
        l5.tiles.setCollectible(x: 4, y: 1)
        l5.tiles.setCollectible(x: 4, y: 2)
        l5.tiles.setCollectible(x: 4, y: 3)
        
        l5.tiles.setCollectible(x: 1, y: 4)
        l5.tiles.setCollectible(x: 2, y: 4)
        l5.tiles.setCollectible(x: 3, y: 4)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 5.json") {
            try? l5.json?.write(to: url)
        }
        
        let l6 = Level(name: "Level 6", number: 6, unlocks: nil)
        l6.tiles = TileMap(width: 6, height: 6)
        l6.tiles.setCollectible(x: 1, y: 1)
        l6.tiles.setCollectible(x: 2, y: 2)
        l6.tiles.setCollectible(x: 3, y: 3)
        l6.tiles.setCollectible(x: 4, y: 4)
        l6.tiles.setCollectible(x: 5, y: 5)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 6.json") {
            try? l6.json?.write(to: url)
        }
        
        // Call levelManager to save unlocked levels in Core Data
        LevelManager.markLevel(withName: l2.name, asUnlocked: false)
        LevelManager.markLevel(withName: l3.name, asUnlocked: false)
        LevelManager.markLevel(withName: l4.name, asUnlocked: false)
        LevelManager.markLevel(withName: l5.name, asUnlocked: false)
        LevelManager.markLevel(withName: l6.name, asUnlocked: false)
        LevelManager.markLevel(withName: l1.name, asUnlocked: true) { [unowned self] in
            //Reload view
            self.levels.removeAll()
            self.levels.append(contentsOf: LevelManager.loadAllLevels())
            self.levelSelectCollectionView.reloadData()
        }
    }
}
