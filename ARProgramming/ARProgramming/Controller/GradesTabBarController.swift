//
//  GradesTabBarController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class GradesTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChildViewControllers()
    }
    
    private func configureChildViewControllers() {
        for i in 0 ..< self.children.count {
            let grade = i + 1
            
            tabBar.items?[i].title = "\(grade). Klasse"
            
            if var child = children[i] as? GradeViewController {
                child.grade = grade
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

protocol GradeViewController {
    var grade: Int! { get set }
}
