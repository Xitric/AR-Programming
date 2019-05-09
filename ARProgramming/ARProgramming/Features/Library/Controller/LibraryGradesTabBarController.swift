//
//  LibraryGradesTabBarController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 08/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
class LibraryGradesTabBarController: GradesTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createHelpButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func createHelpButton() {
        let button1 = UIBarButtonItem(title: "?", style: .plain, target: self, action: #selector(LibraryGradesTabBarController.goToHelpView(_:)))
        self.navigationItem.rightBarButtonItem = button1
    }

    @objc private func goToHelpView(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "HelpSegue", sender: nil)
    }

}
