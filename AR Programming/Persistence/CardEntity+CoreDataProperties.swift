//
//  CardEntity+CoreDataProperties.swift
//  AR Programming
//
//  Created by Emil Nielsen on 23/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//
//

import Foundation
import CoreData


extension CardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardEntity> {
        return NSFetchRequest<CardEntity>(entityName: "CardEntity")
    }

    @NSManaged public var descr: String?
    @NSManaged public var name: String?

}
