//
//  CardDetailViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardDetailViewController: UIViewController {

    var text:String?
    
    @IBOutlet weak var cardText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardText.text = text ?? ""
    }
}
