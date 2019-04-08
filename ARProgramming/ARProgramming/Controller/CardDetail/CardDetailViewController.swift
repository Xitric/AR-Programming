//
//  CardDetailViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class CardDetailViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var parameterLabel: UILabel!
    
    // Injected properties
    var card: Card!
    var cardPreview: UIImage?
    var levelManager: LevelManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = NSLocalizedString("\(card.internalName).name", comment: "")
        summaryLabel.text = NSLocalizedString("\(card.internalName).summary", comment: "")
        descriptionLabel.text = NSLocalizedString("\(card.internalName).description", comment: "")
        previewImage.image = cardPreview
        
        typeLabel.text = NSLocalizedString("cardType.\(card.type)", comment: "")
        if card.supportsParameter {
            parameterLabel.text = NSLocalizedString("card.parameterSupported", comment: "") + " "
                + NSLocalizedString("\(card.internalName).parameter", comment: "")
        } else {
            parameterLabel.text = NSLocalizedString("card.parameterUnsupported", comment: "")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let arContainer as ARContainerViewController:
            arContainer.level = levelManager.emptylevel
        case let exampleProgram as ExampleProgramViewController:
            exampleProgram.view.translatesAutoresizingMaskIntoConstraints = false
            exampleProgram.showExamples(forCard: card)
        default:
            break
        }
    }
}
