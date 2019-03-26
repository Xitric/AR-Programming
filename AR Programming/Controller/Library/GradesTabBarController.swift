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
        tabBar.items?[0].title = "1. Klasse"
        tabBar.items?[1].title = "2. Klasse"
        tabBar.items?[2].title = "3. Klasse"
        tabBar.items?[3].title = "4. Klasse"
        
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
