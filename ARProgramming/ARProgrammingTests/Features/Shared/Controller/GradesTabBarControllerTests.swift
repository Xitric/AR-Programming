//
//  GradesTabBarControllerTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

class GradesTabBarControllerTests: XCTestCase {

    private var controller: GradesTabBarController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Library", bundle: Bundle.main)
        controller = storyboard.instantiateViewController(withIdentifier: "UITabBarController-BnG-xc-Ia5") as? GradesTabBarController
    }

    func testExample() {
        //Act
        controller.viewDidLoad()

        //Assert
        var grade = 0
        for child in controller.children {
            grade += 1

            XCTAssertTrue(child is GradeViewController)
            let gradeController = child as! GradeViewController
            XCTAssertEqual(gradeController.grade, grade)
        }
    }
}
