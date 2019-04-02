//
//  GradesTabBarController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class GradesTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        configureChildViewControllers()
        createHelpButton()
    }
    
    private func configureChildViewControllers() {
        for i in 0 ..< self.children.count {
            let grade = i + 1
            
            //TODO: To reuse this in the LevelSelectViewController, we can introduce a GradeViewController protocol that exposes just the grade variable
            tabBar.items?[i].title = "\(grade). Klasse"
            if let child = children[i] as? CardLibraryViewController {
                child.grade = grade
            }
        }
    }
    
    private func createHelpButton() {
        let button1 = UIBarButtonItem(title: "?", style: .plain, target: self, action: #selector(GradesTabBarController.goToHelpView(_:)))
        self.navigationItem.rightBarButtonItem = button1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func goToHelpView(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "HelpSegue", sender: nil)
    }
}
