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
    
    var cardTitle: String?
    var cardSummary: String?
    var cardDescription: String?
    var cardPreview: UIImage?
    var cardType: String?
    var cardParameterExplanation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = cardTitle ?? "ERROR"
        summaryLabel.text = cardSummary ?? "ERROR"
        descriptionLabel.text = cardDescription ?? "ERROR"
        previewImage.image = cardPreview
        typeLabel.text = cardType ?? "ERROR"
        parameterLabel.text = cardParameterExplanation ?? "ERROR"
    }
}
