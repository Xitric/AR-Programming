//
//  WardrobeManager.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WardrobeManager: WardrobeRepository {

    private let context: CoreDataRepository
    private let targetDirectory = "/Meshes.scnassets/Robot"

    init(context: CoreDataRepository) {
        self.context = context
    }

    func getFileNames() throws -> [String] {
        var fileNames: [String] = []

        if let path = Bundle(for: type(of: self)).resourcePath {
            let files = try FileManager.default.contentsOfDirectory(atPath: path + targetDirectory)

            for name in files {
                let extensionIndex = name.firstIndex(of: ".") ?? name.endIndex
                let fileName = "Robot/\(name[..<extensionIndex])"
                fileNames.append(fileName)
            }
        }

        return fileNames
    }

    func selectedRobotSkin(completion: @escaping (String?, Error?) -> Void) {
        let managedObjectContext = context.persistentContainer.viewContext

        managedObjectContext.perform { [weak self] in
            let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")

            do {
                //Attempt to get stored choice
                let result = try managedObjectContext.fetch(request)
                if let choice = result.first?.choice {
                    completion(choice, nil)
                    return
                }

                //Get default choice if nothing is stored
                if let robotFiles = try self?.getFileNames() {
                    //We also store this default choice in CoreData to make future requests simpler
                    self?.setRobotSkin(named: robotFiles[0]) { error in
                        if error == nil {
                            completion(robotFiles[0], nil)
                        } else {
                            completion(nil, error)
                        }
                    }
                }
            } catch let error {
                completion(nil, error)
            }
        }
    }

    func setRobotSkin(named choice: String, completion: @escaping (Error?) -> Void) {
        let managedObjectContext = context.persistentContainer.viewContext

        managedObjectContext.perform { [weak self] in
            let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")

            do {
                let result = try managedObjectContext.fetch(request)
                if result.count == 0 {
                    //Nothing is stored in CoreData, so we make a new entry
                    let robotEntity = NSEntityDescription.entity(forEntityName: "RobotEntity", in: managedObjectContext)
                    let newRobotEntity = RobotEntity(entity: robotEntity!, insertInto: managedObjectContext)
                    newRobotEntity.setValue(choice, forKey: "choice")
                } else {
                    //We overwrite the existing entry in CoreData
                    result[0].setValue(choice, forKey: "choice")
                }

                self?.context.saveContext()
                completion(nil)
            } catch let error {
                completion(error)
            }
        }
    }
}

/// A protocol describing an object that can be used to manage the user's selection of robot skin.
///
/// The methods on this protocol describe mostly asynchronous actions, even though the implementation happens to be fast enough for the methods to run synchronously. This is because the interface should not make any assumptions about specific implementations, and thus it must expect that they run with worst case performance.
protocol WardrobeRepository {

    /// Synchronously fetches a list of names of all available robots. These names can be used in subsequent calls to set the user's choice of robot.
    ///
    /// - Returns: The collection of robot names.
    /// - Throws: If something went wrong with reading the robot names. This should never happen.
    func getFileNames() throws -> [String]

    /// Aynchronously get the user's choice of robot skin.
    ///
    /// If the user has not made a selection, this method will simply return a default skin.
    ///
    /// - Parameter completion: Closure to be called with either the user's choice of robot or the error that occured when running the method. Exactly one of these will be nil.
    func selectedRobotSkin(completion: @escaping (String?, Error?) -> Void)

    /// Asynchronously set the user's choice of robot skin.
    ///
    /// - Parameters:
    ///   - choice: The user's choice of skin.
    ///   - callback: Closure to be called when the operation finishes. If an error has occured, the error will be supplied to this closure. Otherwise, the error will be nil.
    func setRobotSkin(named choice: String, completion: @escaping (Error?) -> Void)
}
