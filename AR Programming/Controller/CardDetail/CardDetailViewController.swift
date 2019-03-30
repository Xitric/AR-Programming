//
//  CardDetailViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardDetailViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var programExampleTable: UITableView! {
        didSet {
            programExampleTable.dataSource = dataSource
        }
    }
    @IBOutlet weak var sceneView: SCNView!
    
    private lazy var dataSource: ExampleProgramTableDataSource = {
        let source = ExampleProgramTableDataSource()
        return source
    }()
    
    var card: Card!
    var cardPreview: UIImage?
    
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
}
