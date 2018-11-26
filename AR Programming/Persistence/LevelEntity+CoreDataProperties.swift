//
//  LevelEntity+CoreDataProperties.swift
//  AR Programming
//
//  Created by Emil Nielsen on 26/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//
//

import Foundation
import CoreData


extension LevelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LevelEntity> {
        return NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
    }

    @NSManaged public var unlocked: Bool
    @NSManaged public var level: Int16

}
