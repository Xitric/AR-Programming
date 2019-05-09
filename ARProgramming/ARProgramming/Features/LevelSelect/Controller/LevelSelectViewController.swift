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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var levelSelectCollectionView: UICollectionView! {
        didSet {
            levelSelectCollectionView.dataSource = dataSource
            levelSelectCollectionView.delegate = self
        }
    }
    
    //MARK: - Observers
    private var levelObserver: Observer?
    
    //MARK: - Injected properties
    var grade: Int! {
        didSet {
            self.dataSource.grade = grade
        }
    }
    var viewModel: LevelSelectViewModeling!
    var dataSource: LevelDataSource!
    
    deinit {
        levelObserver?.release()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.reloadData() { [weak self] in
            self?.collectionView.reloadData()
        }
        
        levelObserver = viewModel.level.observeFuture { [weak self] level in
            self?.performSegue(withIdentifier: "arContainerSegue", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        levelObserver?.release()
    }
}

// MARK: - UICollectionViewDelegate
extension LevelSelectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let levelCell = collectionView.cellForItem(at: indexPath) as? LevelCollectionViewCell {
            viewModel.loadLevel(withNumber: levelCell.levelNumber!)
        }
    }
}
