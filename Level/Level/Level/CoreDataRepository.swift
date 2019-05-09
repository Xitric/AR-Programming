//
//  CoreDataRepository.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 08/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataRepository {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = LevelPersistentContainer(name: "LevelModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//Force Core Data to search the bundle of this framework rather than the main app bundle
private class LevelPersistentContainer: NSPersistentContainer { }
