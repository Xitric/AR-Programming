//
//  LevelSelectViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private var levels = [Level]()
    var selectedLevel: Level?
    
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = self
            levelSelectCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        levels.append(contentsOf: LevelManager.loadAllLevels())
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
        performSegue(withIdentifier: "unwindToPlay", sender: self)
    }
    
    @IBAction func recreateLevels(_ sender: Any) {
        let l1 = Level(name: "Level 1", number: 1, unlocks: "Level 2")
        l1.cards = [Int:Card]()
        l1.cards[0] = CardFactory.instance.getCard(named: "start")
        l1.cards[1] = CardFactory.instance.getCard(named: "move")
        l1.tiles = TileMap(width: 2, height: 1)
        l1.tiles.setCollectible(x: 1, y: 0)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 1.json") {
            do {
                try l1.json?.write(to: url)
            } catch {
                //Ignore
            }
        }
        
        let l2 = Level(name: "Level 2", number: 2, unlocks: "Level 3")
        l2.cards = [Int:Card]()
        l2.cards[0] = CardFactory.instance.getCard(named: "start")
        l2.cards[1] = CardFactory.instance.getCard(named: "move")
        l2.cards[2] = CardFactory.instance.getCard(named: "move")
        l2.cards[3] = CardFactory.instance.getCard(named: "move")
        l2.cards[4] = CardFactory.instance.getCard(named: "move")
        l2.cards[5] = CardFactory.instance.getCard(named: "right")
        l2.tiles = TileMap(width: 3, height: 3)
        l2.tiles.setCollectible(x: 1, y: 0)
        l2.tiles.setCollectible(x: 2, y: 0)
        l2.tiles.setCollectible(x: 2, y: 1)
        l2.tiles.setCollectible(x: 2, y: 2)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 2.json") {
            do {
                try l2.json?.write(to: url)
            } catch {
                //Ignore
            }
        }
        
        let l3 = Level(name: "Level 3", number: 3, unlocks: nil)
        l3.cards = [Int:Card]()
        l3.cards[0] = CardFactory.instance.getCard(named: "start")
        l3.cards[1] = CardFactory.instance.getCard(named: "move")
        l3.cards[2] = CardFactory.instance.getCard(named: "move")
        l3.cards[3] = CardFactory.instance.getCard(named: "move")
        l3.cards[4] = CardFactory.instance.getCard(named: "move")
        l3.cards[5] = CardFactory.instance.getCard(named: "right")
        l3.tiles = TileMap(width: 5, height: 5)
        l3.tiles.setCollectible(x: 0, y: 1)
        l3.tiles.setCollectible(x: 0, y: 2)
        l3.tiles.setCollectible(x: 0, y: 3)
        
        l3.tiles.setCollectible(x: 1, y: 0)
        l3.tiles.setCollectible(x: 2, y: 0)
        l3.tiles.setCollectible(x: 3, y: 0)
        
        l3.tiles.setCollectible(x: 4, y: 1)
        l3.tiles.setCollectible(x: 4, y: 2)
        l3.tiles.setCollectible(x: 4, y: 3)
        
        l3.tiles.setCollectible(x: 1, y: 4)
        l3.tiles.setCollectible(x: 2, y: 4)
        l3.tiles.setCollectible(x: 3, y: 4)
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Level 3.json") {
            do {
                try l3.json?.write(to: url)
            } catch {
                //Ignore
            }
        }
        
        LevelManager.markLevel(withName: "Level 1", asUnlocked: true)
    }
}
