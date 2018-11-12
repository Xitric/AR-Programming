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

    var cardTitle:String?
    var cardDescription:String?
    var cardImage:UIImage?

    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardTitleLabel.text = cardTitle ?? ""
        cardDescriptionLabel.text = cardDescription ?? ""
        cardImageView.image = cardImage
    }
}
