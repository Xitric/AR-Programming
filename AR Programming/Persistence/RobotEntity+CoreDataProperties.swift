//
//  RobotEntity+CoreDataProperties.swift
//  
//  
//  Created by Emil Nielsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//
//

import Foundation
import CoreData


extension RobotEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RobotEntity> {
        return NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
    }

    @NSManaged public var choice: String?

}
